variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "VPC Primary CIDR"
    
  
}

variable "public_subnets_cidr" {
   type = list(string)
   default = [ "10.0.0.0/19","10.0.32.0/19" ]
  
}

variable "private_subnets_cidr" {
   type = list(string)
   default = [ "10.0.64.0/18","10.0.128.0/17" ]
  
}



