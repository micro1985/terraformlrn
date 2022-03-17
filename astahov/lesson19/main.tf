provider "aws" {}

provider "aws" {
  region = "us-east-1"
  alias  = "USA"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "GER"
}

#-----------------------------------------------------------------

data "aws_ami" "latest_default_Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_USA_Amazon_Linux" {
  provider    = aws.USA
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_GER_Amazon_Linux" {
  provider    = aws.GER
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
}

#-------------------------------------------------------------------

resource "aws_instance" "my_default_server" {
  ami           = data.aws_ami.latest_default_Amazon_Linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Default Server"
  }
}

resource "aws_instance" "my_usa_server" {
  provider      = aws.USA
  ami           = data.aws_ami.latest_USA_Amazon_Linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "USA Server"
  }
}

resource "aws_instance" "my_ger_server" {
  provider      = aws.GER
  ami           = data.aws_ami.latest_GER_Amazon_Linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "GER Server"
  }
}
