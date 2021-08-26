provider "aws" {}

data "aws_availability_zones" "current_zones" {}
data "aws_region" "current_region" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "my_vpc" {
  tags = {
    Name = "test"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id = data.aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.current_zones.names[0]
  cidr_block = "10.10.0.128/28"
  tags = {
    "Name" = "subnet_1 in ${data.aws_availability_zones.current_zones.names[0]}"
  }
}

output "aws_region" {
  value = data.aws_region.current_region.name
}
output "aws_availability_zones" {
  value = data.aws_availability_zones.current_zones.names
}
output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}
output "default_vpc_id" {
  value = data.aws_vpc.my_vpc.id
}
output "default_vpc_cidr_block" {
  value = data.aws_vpc.my_vpc.cidr_block
}