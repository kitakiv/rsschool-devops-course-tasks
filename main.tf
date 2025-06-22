resource "aws_vpc" "ec2_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "VPC for EC2"
  }
}

