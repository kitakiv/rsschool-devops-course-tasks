resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.ec2_vpc.id

  tags = {
    Name = "Gateway EC2 access"
  }
}