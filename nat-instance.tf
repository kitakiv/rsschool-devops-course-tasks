data "aws_ami" "nat_instance" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "nat_instance" {
  ami                         = data.aws_ami.nat_instance.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  subnet_id                   = aws_subnet.public_subnets[0].id
  key_name                    = var.nat_key.key_name
  associate_public_ip_address = true
  source_dest_check           = false

  user_data = <<-EOF
    #!/bin/bash
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    # Make iptables rules persistent
    yum install -y iptables-services
    systemctl enable iptables
    systemctl start iptables
    service iptables save
  EOF

  tags = {
    Name = "NAT Instance"
  }
}

resource "aws_key_pair" "nat_key" {
  key_name   = var.nat_key.key_name
  public_key = var.nat_key.public_key
}
