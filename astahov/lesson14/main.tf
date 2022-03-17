terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
}

locals {
  az_list  = join(",", data.aws_availability_zones.available.names)
  region   = data.aws_region.current.description
  location = "In ${local.region} there are AZ: ${local.az_list}"
}

resource "aws_eip" "my_static_ip" {

  tags = {
    Name          = "Static IP"
    Owner         = var.owner
    Project       = local.full_project_name
    Project_Owner = local.project_owner
    AZ_List       = local.az_list
    Location      = local.location
  }
}
