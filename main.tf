terraform {
  required_version = "~>1.8.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.26.0"
    }
  }

}

provider "aws" {
    region = "eu-west-2"
  
}

resource "aws_instance" "name" {

    ami = "ami-035cecbff25e0d91e"
    instance_type = "t2.micro"
    availability_zone = "eu-west-2a"
    key_name = "subina.pem"
    tags = {
      "Name" = "DevOPs Instance"
    }
  
}