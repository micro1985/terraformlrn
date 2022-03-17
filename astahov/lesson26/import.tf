resource "aws_instance" "node1" {
  ami                    = "ami-0ac001e37d0d00e35"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nomad.id]
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
    Name       = "MyLinuxServer1"
    Owner      = "xenn"
    ONEMORETAG = "TAG"
  }
}

resource "aws_instance" "node2" {
  ami                    = "ami-0ac001e37d0d00e35"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nomad.id]
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
    Name       = "MyLinuxServer2"
    Owner      = "xenn"
    ONEMORETAG = "TAG"
  }
}

resource "aws_instance" "node3" {
  ami                    = "ami-0ac001e37d0d00e35"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nomad.id]
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
    Name       = "MyLinuxServer3"
    Owner      = "xenn"
    ONEMORETAG = "TAG"
  }
}

resource "aws_security_group" "nomad" {
  description = "linux_SG"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "linux_SG"
    Owner      = "xenn"
    ONEMORETAG = "TAG"
  }
}
