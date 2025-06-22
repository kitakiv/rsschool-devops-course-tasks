
resource "aws_instance" "ec2_public" {

  count                       = length(aws_subnet.public_subnets)
  subnet_id                   = aws_subnet.public_subnets[count.index].id
  instance_type               = var.ec2_settings.instance_type
  ami                         = var.ec2_settings.ami
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  associate_public_ip_address = true
  user_data              = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello this is public ${count.index + 1}</h1></body></html>" > /var/www/html/index.html
      EOF

  tags = {
    Name = "ec2_public_${count.index + 1}"
  }
}

resource "aws_instance" "ec2_private" {

  count                  = length(aws_subnet.private_subnets)
  subnet_id              = aws_subnet.private_subnets[count.index].id
  instance_type          = var.ec2_settings.instance_type
  ami                    = var.ec2_settings.ami
  vpc_security_group_ids = [aws_security_group.security_group.id]
  user_data              = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello this is private ${count.index + 1}</h1></body></html>" > /var/www/html/index.html
      EOF

  tags = {
    Name = "ec2_private_${count.index + 1}"
  }
}