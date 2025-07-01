
resource "random_password" "k3s_token" {
  length  = 64
  special = false
}

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

resource "aws_instance" "ec2_private_master" {
  subnet_id              = aws_subnet.private_subnets[0].id
  instance_type          = var.k3s_settings.instance_type
  ami                    = var.k3s_settings.ami
  key_name               = var.private_subnet_key.key_name
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]


  user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail

  apt-get update -y
  apt-get install -y curl

  curl  -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" K3S_TOKEN="${random_password.k3s_token.result}" sh -
  sleep 60
  kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml


  EOF

  tags = {
    Name = "k3s_master"
  }
}

resource "aws_instance" "ec2_private_worker" {

  subnet_id              = aws_subnet.private_subnets[1].id
  instance_type          = var.k3s_settings.instance_type
  ami                    = var.k3s_settings.ami
  key_name               = var.private_subnet_key.key_name
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail

  apt-get update -y
  apt-get install -y curl
  sleep 60
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" K3S_URL="https://${aws_instance.ec2_private_master.private_ip}:6443" K3S_TOKEN="${random_password.k3s_token.result}" sh -
  EOF


  tags = {
    Name = "k3s_worker"
  }
}

resource "aws_key_pair" "deployer_private" {
  key_name   = var.private_subnet_key.key_name
  public_key = var.private_subnet_key.public_key
}