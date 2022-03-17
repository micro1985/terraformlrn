provider "aws" {}

terraform {
  backend "s3" {
    bucket = "xenn-terraform-state"
    key    = "globalvars/terraform.tfstate"
    //region = "eu-north-1"
  }
}

output "company_name" {
  value = "NIISA"
}

output "owner" {
  value = "xenn"
}

output "tags" {
  value = {
    Project = "Assemby-2022"
    Name    = "Bubu"
    Country = "Not Belarus"
  }
}
