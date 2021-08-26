provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-*"]
  }
}

data "aws_ami" "latest_Amazon_Linux_2" {
  owners = [ "amazon" ]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}
output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_Amazon_Linux_2_id" {
  value = data.aws_ami.latest_Amazon_Linux_2.id
}
output "latest_Amazon_Linux_2_name" {
  value = data.aws_ami.latest_Amazon_Linux_2.name
}