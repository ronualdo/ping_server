resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/20"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    name = "ping-server-vpc"
  }
}

resource "aws_subnet" "pub_subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/22"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pub_subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/22"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "external_gateway" {
  vpc_id = aws_vpc.main.id 
}

resource "aws_route_table" "external_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.external_gateway.id
  }
}

resource "aws_route_table_association" "pub_subnet1" {
  subnet_id = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.external_route.id
}

resource "aws_route_table_association" "pub_subnet2" {
  subnet_id = aws_subnet.pub_subnet2.id
  route_table_id = aws_route_table.external_route.id
}
