# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  version    = "~> 2.0"
  region     = "us-east-1"
  access_key = "AKIAXAX23PMHLRXOQU72"
  secret_key = "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"
}

data "aws_subnet" "selected_subnet" {
  vpc_id = "vpc-a02c7dda"
  id     = "subnet-29929475"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  count         = "4"
  ami           = "ami-0c6b1d09930fac512"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected_subnet.id
  tags = {
    name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  count         = "2"
  ami           = "ami-0c6b1d09930fac512"
  instance_type = "m4.large"
  subnet_id     = "subnet-29929475"
  tags = {
    name = "Udacity M4"
  }
}
