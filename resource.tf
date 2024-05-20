resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    "Name" = "demo-vpc"
    "Environment" = "Dev"

  }
}

resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnets_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = element(var.public_subnets_cidr,count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

    tags = {
        "Name" = "Public_Subnet"
  }
}


resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnets_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = element(var.private_subnets_cidr,count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        "Name" = "Private_Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }


    tags = {
        "Name" = "Public-RT"
    }
  
}

resource "aws_route_table_association" "public-rt-associate" {
    count = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "elastic_ip" {
  count = length(var.public_subnets_cidr)
  domain   = "vpc"
  tags = {
    "Name" = "Elastic-IP"
  }
}

resource "aws_nat_gateway" "natgateways" {
    count = length(var.public_subnets_cidr)
  allocation_id = aws_eip.elastic_ip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private_rt" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.main.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgateways[count.index].id

    }


    tags = {
        "Name" = "Private-RT"
    }
  
}

resource "aws_route_table_association" "private-rt-associate" {
    count = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}