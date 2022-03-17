provider "aws" {}

resource "aws_instance" "my_terraform_Ubuntu" {
  //  count         = 2
  ami           = "ami-092cce4a19b438926"
  instance_type = "t3.micro"

  tags = {
    Name    = "MyUbuntuServer"
    Owner   = "xenn"
    Project = "terraform learn"
  }
}

resource "aws_instance" "my_terraform_Amazon" {
  ami           = "ami-06077dff17d5cd454"
  instance_type = "t3.micro"

  tags = {
    Name    = "MyAmazonSeubunturver"
    Owner   = "xenn"
    Project = "terraform learn"
  }
}
