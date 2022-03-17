provider "aws" {}

terraform {
  backend "s3" {
    bucket = "xenn-terraform-state"
    key    = "dev/servers/terraform.tfstate"
    //region = "eu-north-1"
  }
}

variable "env" {
  default = "dev"
}

#-------------------------------------------------------------

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "xenn-terraform-state"
    key    = "dev/network/terraform.tfstate"
    //region = "eu-north-1"
  }
}

data "aws_ami" "latest_Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
}

#-------------------------------------------------------------

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.latest_Amazon_Linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform with Remote State"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

  tags = {
    Name = "${var.env}-WebServer"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = ["80", "443", "1541", "3306", "9098"]
    //for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
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


output "webserver_sg_id" {
  value = aws_security_group.webserver_sg.id
}

output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}
