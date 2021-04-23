terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.34.0"
    }
  }
}

provider "aws" {}

resource "aws_instance" "my-server" {
  ami           = "ami-0767046d1677be5a0"
  instance_type = "t2.micro"
  tags = {
    Name = "jenkins_tf_deployment"
  }
}
