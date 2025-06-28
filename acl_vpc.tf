resource "aws_network_acl" "public" {

  vpc_id     = aws_vpc.ec2_vpc.id

  subnet_ids = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]


  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0

  }

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0

  }



  tags = {
    Name = "PublicNACL"
  }

}