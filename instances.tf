
resource "aws_instance" "ec2_public" {

  count                       = length(aws_subnet.public_subnets)
  subnet_id                   = aws_subnet.public_subnets[count.index].id
  instance_type               = var.ec2_settings.instance_type
  ami                         = var.ec2_settings.ami
  key_name                    = var.ec2_settings.key_name
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "ec2_public_${count.index + 1}"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.ec2_settings.key_name
  public_key = var.ec2_settings.public_key
}

resource "aws_instance" "ec2_private" {

  count                  = length(aws_subnet.private_subnets)
  subnet_id              = aws_subnet.private_subnets[count.index].id
  instance_type          = var.ec2_settings.instance_type
  ami                    = var.ec2_settings.ami
  key_name               = var.private_subnet_key.key_name
  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    Name = "ec2_private_${count.index + 1}"
  }
}

resource "aws_key_pair" "deployer_private" {
  key_name   = var.private_subnet_key.key_name
  public_key = var.private_subnet_key.public_key
}