provider "aws" {}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow HTTP inbound traffic"
  //vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "3306", "9098"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    //    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "allow_http"
    Owner = "xenn"
  }
}
