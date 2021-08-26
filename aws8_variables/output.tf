output "my_server_ip" {
  value = aws_eip.my_elastic_ip.public_ip
}
output "my_instance_id" {
  value = aws_instance.my_instance.id
}
output "my_sg_id" {
  value = aws_security_group.allow_http.id
}