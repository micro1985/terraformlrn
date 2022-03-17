provider "aws" {}

variable "env" {
  default = "dev"
}

variable "prod_owner" {
  default = "xenn"
}

variable "not_prod_owner" {
  default = "Dyadya Vasya"
}

variable "ec2_size" {
  default = {
    "prod"    = "t3.large"
    "dev"     = "t3.micro"
    "staging" = "t3.small"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

resource "aws_instance" "my_webserver1" {
  ami = "ami-06077dff17d5cd454"
  //instance_type = var.env == "prod" ? "t3.large" : "t3.micro"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}

resource "aws_instance" "my_webserver2" {
  ami           = "ami-06077dff17d5cd454"
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}

resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-06077dff17d5cd454"
  instance_type = "t3.micro"

  tags = {
    Name = "Bastion Server for DEV"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow HTTP inbound traffic"
  //vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    //for_each = ["80", "443", "8080", "1541", "3306", "9098"]
    for_each = lookup(var.allow_port_list, var.env)
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
    //    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "allow_http"
    Owner = "xenn"
  }
}
