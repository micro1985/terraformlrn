output "webserver-instance-id" {
  value = aws_instance.my_web_server.id
}

output "webserver-public-ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver-security-group-id" {
  value = aws_security_group.webserver_sg.id
}

output "webserver-security-group-arn" {
  value = aws_security_group.webserver_sg.arn
}
