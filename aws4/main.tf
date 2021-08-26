provider "aws" {
  region     = "eu-north-1"
}

resource "aws_eip" "my_elastic_ip" {
  instance = aws_instance.myinstance.id
}

resource "aws_instance" "myinstance" {
  ami           = "ami-0d441f5643da997cb"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Sasha",
    l_name = "Gatsiha"
    names = ["Vasya", "Masha", "George", "Kap4eniy", "Kimi", "Busenkin!!!"]
  })

  tags = {
    Name = "MyInstance"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
#  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

output "server_id" {
  value = aws_instance.myinstance.id
}

output "server_public_ip" {
  value = aws_instance.myinstance.public_ip
}