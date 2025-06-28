resource "aws_network_acl" "acl_for_subnets" {
  vpc_id     = aws_vpc.ec2_vpc.id
  subnet_ids = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]

  egress {
    protocol   = -1
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = "allow"
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.port
      to_port    = ingress.value.port
    }
  }

  tags = {
    Name = "ACL for subnets"
  }
}