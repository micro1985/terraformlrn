provider "aws" {}

/*resource "aws_instance" "node1" {
  ami           = "ami-0ac001e37d0d00e35"
  instance_type = "t3.micro"

  tags = {
    Name       = "Node-1"
    Owner      = "xenn"
    ONEMORETAG = "TAG"
  }
}*/

resource "aws_instance" "node2" {
  ami           = "ami-0ac001e37d0d00e35"
  instance_type = "t3.micro"

  tags = {
    Name       = "Node-2"
    Owner      = "xenn"
    ONEMORETAG = "TAG"
  }
}

resource "aws_instance" "node3" {
  ami           = "ami-0ac001e37d0d00e35"
  instance_type = "t3.micro"

  depends_on = [aws_instance.node2]

  tags = {
    Name       = "Node-3"
    Owner      = "xenn"
    ONEMORETAG = "TAG"
  }
}
