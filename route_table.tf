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