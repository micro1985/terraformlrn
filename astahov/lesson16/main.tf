/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.0"
    }
  }
}*/

provider "aws" {}

variable "name" {
  default = "Vasya"
}

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&"
  keepers = {
    keeper1 = var.name
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master password for RDS MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

/*data "aws_ssm_parameter" "my_rds_password" {
  name = "/prod/mysql"

  depends_on = [aws_ssm_parameter.rds_password]
}*/

resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "prod"
  username             = "admin"
  password             = aws_ssm_parameter.rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true

  depends_on = [aws_ssm_parameter.rds_password]
}

/*output "rds_password" {
  value = nonsensitive(data.aws_ssm_parameter.my_rds_password.value)
}
*/
