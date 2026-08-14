# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

# Public Subnets
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet1_cidr_block
  availability_zone       = var.public_subnet1_az
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet1_name
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet2_cidr_block
  availability_zone       = var.public_subnet2_az
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet2_name
  }
}

# Private Subnets
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet1_cidr_block
  availability_zone       = var.private_subnet1_az
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet1_name
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet2_cidr_block
  availability_zone       = var.private_subnet2_az
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet2_name
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.vpc_name}-Public-Route-Table"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway - AZ1
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-az1"
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public1.id
  tags = {
    Name = "nat-gw-az1"
  }
}

# NAT Gateway - AZ2
resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-az2"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public2.id
  tags = {
    Name = "nat-gw-az2"
  }
}

# Private Route Table AZ1
resource "aws_route_table" "private_rt_az1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = {
    Name = "private-rt-az1"
  }
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt_az1.id
}

# Private Route Table AZ2
resource "aws_route_table" "private_rt_az2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }
  tags = {
    Name = "private-rt-az2"
  }
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt_az2.id
}