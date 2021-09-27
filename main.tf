provider "aws" {
access_key = "${var.aws_access_key}"
secret_key = "${var.aws_secret_key}"
region     = "${var.region}"
}

#======== Instance creation ================
resource "aws_instance" "dockerized_petclinic_instance" {
  ami                    = "ami-00399ec92321828f5"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.petclinic_sg.id]
  user_data              = file("spetclinic_remote.sh")
  key_name               = "yoba"

  tags = {
    Name  = "Spring-Petclinic"
    Owner = "Yevhenii Kushnir"
  }
}

resource "aws_db_instance" "petclinic" {
  identifier             = "petclinic"
  port                   = 3306
  allocated_storage      = "5"
  engine                 = "mysql"
  engine_version         = "5.7.21"
  instance_class         = "db.t2.micro"
  name                   = "PetClinic"
  username               = "petclinic"
  password               = "petclinic"
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.petclinic_sg.id]
  skip_final_snapshot    = true
}

/* resource "aws_security_group" "petclinic_sg_rds" {
  vpc_id = aws_vpc.petclinic_vpc.id
}
*/
resource "aws_security_group_rule" "petclinic_rds_login" {
  security_group_id = aws_security_group.petclinic_sg.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


#======== Network / VPC ===========
resource "aws_vpc" "petclinic_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "PetClinicVPC"
  }
}
#======== Subnet ===========

resource "aws_subnet" "petclinic_subnet" {
  vpc_id     = aws_vpc.petclinic_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "PetClinicSN"
  }
}

#======== Security Group creation ===========
resource "aws_security_group" "petclinic_sg" {
  name        = "petclinic_sg"
  description = "Spring-Petclinic Security Group"


  ingress {
    description = "TLS from VPC"
    from_port   = "0"
    to_port     = "8081"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "petclinic_sg"
  }
}

#======== Launch Template & Autoscaling Group ================
resource "aws_launch_template" "petclinic_lt" {
  name_prefix   = "petclinic_lt"
  image_id      = "ami-00399ec92321828f5"
  instance_type = "t2.micro"
  tags = {
    Name = "PetClinicLT"
  }
}

resource "aws_autoscaling_group" "petclinic_asg" {
  #vpc_zone_identifier = [aws_subnet.petclinic_subnet.id]
  availability_zones  = ["us-east-2a","us-east-2b"]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.petclinic_lt.id
    version = "$Latest"
  }
}

#======== Scripts ================

resource "null_resource" "instance_id" {
  provisioner "local-exec" {
    command = "touch instance_id.txt && echo $instance > instance_id.txt"
    environment = {
      instance = aws_instance.dockerized_petclinic_instance.public_dns
    }
  }
  depends_on = [aws_instance.dockerized_petclinic_instance]
}

resource "null_resource" "db_instance_id" {
  provisioner "local-exec" {
    command = "touch db_instance_id.txt && echo $db_instance | awk -F: '{print $1}' >  db_instance_id.txt"
    environment = {
      db_instance = aws_db_instance.petclinic.endpoint
    }
  }
  depends_on = [aws_db_instance.petclinic]
}
resource "null_resource" "local_part" {
  provisioner "local-exec" {
    command     = "spetclinic_local.sh"
    interpreter = ["/bin/bash"]
  }
  depends_on = [null_resource.instance_id, aws_instance.dockerized_petclinic_instance, aws_db_instance.petclinic]
}
output "EC2_Instance_IPv4_address" {
  value = "${aws_instance.dockerized_petclinic_instance.public_ip}"
}
output "rds_endpoint" {
  value = "${aws_db_instance.petclinic.endpoint}"
}
