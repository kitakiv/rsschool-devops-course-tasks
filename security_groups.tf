resource "aws_security_group" "security_group" {
  name        = "resource_with_dynamic_block"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ec2_vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = [ingress.value.cidr_block]
      security_groups  = []
      self             = false
      prefix_list_ids  = []
      ipv6_cidr_blocks = []
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AWS security group dynamic block"
  }
}

resource "aws_security_group" "private_instance_sg" {
  name        = "private-instance-security-group"
  description = "Allow SSH access from bastion host only"
  vpc_id      = aws_vpc.ec2_vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = []
    description     = "Allow all inbound traffic"
    cidr_blocks     = [var.public_subnet_cidrs[0], var.public_subnet_cidrs[1], var.private_subnet_cidrs[0], var.private_subnet_cidrs[1]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "private-instance-security-group"
  }
}