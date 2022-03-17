provider "aws" {}

resource "aws_instance" "my_web_server" {
  ami                    = "ami-06077dff17d5cd454"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

  tags = {
    Name  = "WebServer"
    Owner = "xenn"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow HTTP inbound traffic"
  //vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    //cidr_blocks = [aws_vpc.main.cidr_block]
    //    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
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
