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
