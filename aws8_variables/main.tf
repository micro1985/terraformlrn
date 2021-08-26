provider "aws" {
  region = var.region
}

#-----------------------------Data Sources------------------------------------------
data "aws_ami" "latest_Amazon_Linux_2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#------------------------------------------------------------------------------------

resource "aws_eip" "my_elastic_ip" {
  instance = aws_instance.my_instance.id

  tags = merge(var.common_tags, { Name = "Server IP Build by Terraform" })
}

resource "aws_instance" "my_instance" {
  ami                    = data.aws_ami.latest_Amazon_Linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  monitoring             = var.detailed_monitoring

  tags = merge(var.common_tags, { Name = "Server Build by Terraform" })

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  #  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allow_ports
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

  tags = merge(var.common_tags, { Name = "Server SG Build by Terraform" })
}