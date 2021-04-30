terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.34.0"
    }
  }
}

provider "aws" {}

resource "aws_vpc" "server-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "server-vpc"
  }
}

resource "aws_subnet" "subnet-uno" {
  cidr_block = "${cidrsubnet(aws_vpc.server-vpc.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.server-vpc.id}"
  availability_zone = "eu-central-1a"
}

resource "aws_security_group" "ingress-all-test" {
  name = "allow-all-sg"
  vpc_id = "${aws_vpc.server-vpc.id}"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSMFYxg3dOpues6EMrI/c3YAE07PAeswnfo9F/5vgh9Wrr7qK6QcQ7Fs+5O5Hm0k3AQoE2sTpANcqITKJsaYnd5i5ii8ehGg7eGPijLv+3Kz4fzxXfOdjSEMkDQemM5RkDnZoM/rS76DF1JF99ls2eJ05bH/l9mB9uXfhCCymwGxmYEF4B2diK4IJ6XQQomOCDXYYd+RQt5GNi1feEVbcjgPw1k9/P16B4Nu2jI1S3iW0xIxkAeoDqu8HiYQJRfG7XR7otcI1zJVrwMQYAtn1SLnQAnd+BpXcT0wGejEItvrOqS7uEChB20xa2345TnBHS5oos4FfjZAYuHpZug9TYOU1w+MxB5+kXOKJP00+IHcsZXdJTOGizHQUQTi9YLBteyY8TD5WICBLmmHieqkZrgMRH3xYq4+kz+OzU+QkUlI2fNv6+l4FLs4G1yA1nRnX5z3TndN9LyU1eqmLHkyP07clNMvpnffbVtMnNvcrS/2GIh6LtnH2utMARHIMqUN0= deployer@deployer"
}

resource "aws_instance" "deploy-server" {
  ami           = "ami-0767046d1677be5a0"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  tags = {
    Name = "jenkins_tf_deployment"
  }
  subnet_id = "${aws_subnet.subnet-uno.id}"
}

resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.deploy-server.id}"
  vpc      = true
}

resource "aws_internet_gateway" "deploy-env-gw" {
  vpc_id = "${aws_vpc.server-vpc.id}"
  tags = {
    Name = "deploy-env-gw"
  }
}

resource "aws_route_table" "route-table-deploy-env" {
  vpc_id = "${aws_vpc.server-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.deploy-env-gw.id}"
  }
  tags = {
    Name = "test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-uno.id}"
  route_table_id = "${aws_route_table.route-table-deploy-env.id}"
}

output "eip" {
    description = "External IP Address"
    value = "${aws_eip.ip-test-env.public_ip}"
}
