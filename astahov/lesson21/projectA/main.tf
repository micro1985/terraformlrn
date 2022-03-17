provider "aws" {
  region = "eu-central-1"
}

/*module "vpc_default" {
  source = "../modules/aws_network"
}
*/
module "vpc_dev" {
  //source = "../modules/aws_network"
  source               = "git::https://github.com/adv4000/terraform-modules.git//aws_network"
  env                  = "development"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = []
}

module "vpc_prod" {
  //source = "../modules/aws_network"
  source               = "git::https://github.com/adv4000/terraform-modules.git//aws_network"
  env                  = "production"
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24", "10.10.33.0/24"]
}

module "vpc_test" {
  //source = "../modules/aws_network"
  source               = "git::https://github.com/adv4000/terraform-modules.git//aws_network"
  env                  = "test"
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24"]
}

output "prod_public_subnet_ids" {
  value = module.vpc_prod.public_subnet_ids
}

output "prod_private_subnet_ids" {
  value = module.vpc_prod.private_subnet_ids
}

output "development_public_subnet_ids" {
  value = module.vpc_dev.public_subnet_ids
}

output "development_private_subnet_ids" {
  value = module.vpc_dev.private_subnet_ids
}
