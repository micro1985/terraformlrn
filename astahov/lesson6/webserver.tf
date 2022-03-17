terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_web_server.id
}

resource "aws_instance" "my_web_server" {
  ami                    = "ami-06077dff17d5cd454"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data = templatefile("user_data.tpl", {
    f_name = "Sasha",
    l_name = "Gats",
    names  = ["Vasya", "John", "Masha", "Donald", "Busen", "Pupen", "Petya", "GoGa"]
  })

  tags = {
    Name  = "WebServer"
    Owner = "xenn"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow HTTP inbound traffic"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "allow_http"
    Owner = "xenn"
  }
}
