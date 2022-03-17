terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

resource "aws_instance" "my_server_web" {
  ami                    = "ami-06077dff17d5cd454"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  tags = {
    Name  = "Server-Web"
    Owner = "xenn"
  }

  depends_on = [aws_instance.my_server_db, aws_instance.my_server_app]
}

resource "aws_instance" "my_server_app" {
  ami                    = "ami-06077dff17d5cd454"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  tags = {
    Name  = "Server-App"
    Owner = "xenn"
  }

  depends_on = [aws_instance.my_server_db]
}

resource "aws_instance" "my_server_db" {
  ami                    = "ami-06077dff17d5cd454"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  tags = {
    Name  = "Server-DB"
    Owner = "xenn"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow HTTP inbound traffic"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
