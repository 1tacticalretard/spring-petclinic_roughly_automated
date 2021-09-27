output "EC2_Instance_IPv4_address" {
  value = "${aws_instance.dockerized_petclinic_instance.public_ip}"
}
output "rds_endpoint" {
  value = "${aws_db_instance.petclinic.endpoint}"
}
