provider "aws" {}

terraform {
  backend "s3" {
    bucket = "xenn-terraform-state"
    key    = "dev/network/terraform.tfstate"
  }
}
