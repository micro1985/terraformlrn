provider "aws" {
  region = "eu-north-1"
}

#-----------------------------Data Sources------------------------------------------
data "aws_availability_zones" "available" {}
data "aws_ami" "latest_Amazon_Linux_2" {
  owners = [ "amazon" ]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#------------------------------------------------------------------------------------

resource "aws_security_group" "my_webserver" {
  name        = "allow_http_on_web_server"
  description = "Allow HTTP inbound traffic"

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
    
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dynamic Security Group"
    Owner = "Sasha Gatsiha"
  }
}

resource "aws_launch_configuration" "web" {
  #name = "WebServer-Highly-Available-LC"
  name_prefix = "WebServer-Highly-Available-LC-"
  image_id = data.aws_ami.latest_Amazon_Linux_2.id
  instance_type = "t3.micro"
  security_groups = [ aws_security_group.my_webserver.id ]
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size = 2
  max_size = 4
  min_elb_capacity = 2
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers = [aws_elb.web.name]

  dynamic "tag" {
      for_each = {
          Name = "WebServer-in-ASG"
          Owner = "Sasha Gatsiha"
          TAGKEY = "TAGVALUE"
      }

      content {
        key = tag.key
        value = tag.value
        propagate_at_launch = true 
      }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-Highly-Available-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.my_webserver.id]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }
  tags = {
    Name = "WebServer-Highly-Available-ELB"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_loadbalancer_URL" {
  value = aws_elb.web.dns_name
}