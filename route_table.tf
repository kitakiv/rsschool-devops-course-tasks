// Route table for public subnets

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  route {
    gateway_id = "local"
    cidr_block = "10.0.0.0/16"
  }

  tags = {
    Name = "Route table EC2 access"
  }

  depends_on = [aws_internet_gateway.gateway]
}


resource "aws_route_table_association" "public_subnet_connect" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.route_table.id
}

// Route table for private subnets

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  route {
    gateway_id = "local"
    cidr_block = "10.0.0.0/16"
  }

  tags = {
    Name = "Private route table EC2 access"
  }

  depends_on = [aws_eip.eip_for_nat_gw, aws_nat_gateway.nat_gw]
}

resource "aws_route_table_association" "private_subnet_connect" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}