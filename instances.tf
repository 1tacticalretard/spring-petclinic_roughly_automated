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