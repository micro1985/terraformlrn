provider "aws" {}

variable "aws_users" {
  description = "List of IAM Users to create"
  default     = ["Vasya", "Petya", "Kolya", "Vova", "Masha", "Donald"]
}

resource "aws_iam_user" "user1" {
  name = "Pushkin"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

output "created_iam_users_all" {
  value = aws_iam_user.users
}

output "created_iam_users_id" {
  value = aws_iam_user.users[*].id
}

output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name} has ARN ${user.arn}"
  ]
}

output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id
  }
}

output "custom_if_length" {
  value = [
    for x in aws_iam_user.users :
    x.name
    if length(x.name) == 5
  ]
}

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-06077dff17d5cd454"
  instance_type = "t3.micro"

  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}

output "server_all" {
  value = {
    for server in aws_instance.servers :
    server.id => server.public_ip
  }
}
