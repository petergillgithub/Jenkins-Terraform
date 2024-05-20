


resource "aws_instance" "name" {

    ami = "ami-035cecbff25e0d91e"
    instance_type = "t2.micro"
    availability_zone = "eu-west-2a"
    key_name = "subina"
    tags = {
      "Name" = "DevOPs Instance"
    }
  
}