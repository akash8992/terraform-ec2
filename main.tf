terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAYS2NTHRS7NGBXWVCAAAAs"
  secret_key = "SlZs6KVcf3aff8HoB4FzwE+4dbwSXj1Vkk4mlM2pAAAAs"
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {
  description = "codezaza"
  default     = "codezaza"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${var.key_name}.pem"
  content  = tls_private_key.rsa_4096.private_key_pem
}

resource "aws_instance" "public_instance" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.key_pair.key_name

  tags = {
    Name = "public_instance"
  }
}
