resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.ec2_vpc.id

  tags = {
    Name = "Gateway EC2 access"
  }
}

resource "aws_eip" "eip_for_nat_gw" {
  domain = "vpc"

  depends_on = [aws_nat_gateway.nat_gw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_for_nat_gw.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "NAT Gateway EC2 access"
  }

  depends_on = [aws_eip.eip_for_nat_gw]
}