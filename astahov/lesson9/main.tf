terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}

data "aws_vpc" "demo_vpc" {
  tags = {
    Name = "DemoVPC"
  }
}

resource "aws_subnet" "demo_subnet1" {
  vpc_id            = data.aws_vpc.demo_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.7.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = "Subnet in Region ${data.aws_region.current.description}"
  }
}

resource "aws_subnet" "demo_subnet2" {
  vpc_id            = data.aws_vpc.demo_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.0.8.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = "Subnet in Region ${data.aws_region.current.description}"
  }
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "data_aws_vpcs_my" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "data_aws_vpcs_demo" {
  value = data.aws_vpc.demo_vpc.id
}

output "data_aws_vpcs_demo_CIDR" {
  value = data.aws_vpc.demo_vpc.cidr_block
}
