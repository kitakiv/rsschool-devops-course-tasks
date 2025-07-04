output "Master_Private_IP" {
  value       = aws_instance.ec2_private_master.private_ip
  description = "Master Private IP"
}

output "Worker_Private_IP" {
  value       = aws_instance.ec2_private_worker.private_ip
  description = "Worker Private IP"
}

output "Bastion_Public_IP_1" {
  value       = aws_instance.ec2_public[0].public_ip
  description = "The First Bastion Public IP"
}

output "Bastion_Public_IP_2" {
  value       = aws_instance.ec2_public[1].public_ip
  description = "The Second Bastion Public IP"
}