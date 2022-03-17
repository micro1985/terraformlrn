/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
*/
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
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

output "latest_Ubuntu_AMI_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_Ubuntu_AMI_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_Amazon_AMI_id" {
  value = data.aws_ami.latest_Amazon_Linux.id
}

output "latest_Amazon_AMI_name" {
  value = data.aws_ami.latest_Amazon_Linux.name
}
