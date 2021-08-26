provider "aws" {
  access_key = "AKIASXGAGHUQ4IHLWCUY"
  secret_key = "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"
  region     = "eu-north-1"
}

resource "aws_instance" "myinstance" {
  ami           = "ami-0d441f5643da997cb"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = <<EOF
#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
echo "${data.local_file.indx.content}" >> /var/www/html/index.html
sudo service httpd start
sudo chkconfig httpd on
EOF

  tags = {
    Name = "MyInstance"
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

data "local_file" "indx" {
    filename = "${path.module}/index.html"
}