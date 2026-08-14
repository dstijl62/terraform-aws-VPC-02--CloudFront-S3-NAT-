
# Elastic IP 1, NAT Gateway 1
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

# Elastic IP 2, NAT Gateway 2
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

# Route Table, Route Table Association

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

# Route Table, Route Table Association

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
