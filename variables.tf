variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "AWS Availability Zones"
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "route_tb_public" {
  type        = string
  description = "Route Table Name for Public Subnets"
  default     = "Public_Route_Table"
}

variable "route_tb_private" {
  type        = string
  description = "Route Table Name for Private Subnets"
  default     = "Private_Route_Table"
}

variable "ec2_settings" {
  type = object({
    ami           = string
    instance_type = string
    key_name      = string
    public_key    = string
    instance_tags = object({
      Name = string
    })
    instance_profile = string
  })
  description = "EC2 Instance Settings"
  default = {
    ami           = "ami-01f23391a59163da9"
    instance_type = "t2.micro"
    key_name      = "demo-instance"
    public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQddYRt5s3bvsSosFvx26tDIySEY4HbTL5/8+UsxGPxXeCuqG7XKiBcXTNpsLNL65cI1Ih9I5ErW1BNT/yiCK8QdZHjt5GIx4Vu3kW/mjezM9G8tsk/C9fMKeRozbU2rYQshU3YmkfaxrnCObvtAFFXm/T90k7lRM37ooVErjMD+sXcAYRakcF5/n7YaU8HN1nZOvoBZHu7LCjdDbZtgUqCZ/mBvspPAUA6lzyrqeZ0iyTRwzcK4bffCmxwGHzewf1MvRSkl7VI6cT5cfmUg2tqX2vokBPzymOkO3kg/8EEaQALAgXt/qidcK11cjo20FP+QqIDT1hFZ+brTAdezfh kitge@Master"
    instance_tags = {
      Name = "EC2 Instance"
    }
    instance_profile = "ec2_instance_profile"
  }
  sensitive = true
}

variable "private_subnet_key" {
  type = object({
    key_name   = string
    public_key = string
  })
  description = "Private Subnet Key"
  default = {
    key_name   = "demo_instance_private"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcKjk7ZdToat2jLwIFdcw20ZQJDnNMEbCJbq0/Jh9tLkiyWlKVRdsEOL+e/e2ItsNT+J6A5QbWZ1W7TWOFaIi7230wXNjjW6T3emGcW2qOUKQe0nRdi5FB0AifTyreW3oDMSzFq0KqIdcWyjcfBxWvVMh6PZpI/1V809NxC5XbTF1bUYGXcdqjxgCDYozgSr0M8Z3JC2PZs4muDJ8CCs3EWFS2P4LeQve59N0VhCeLV6shW1QIvZhP/XybntbjphVOnU13wgOpiasvdv+OrrYChrhBkfotPsl+DDNWufslwi/G+nl0u6bTI7uBYc4SdOayxZWb3gw2qfRDTTDKZwRp kitge@Master"
  }

  sensitive = true
}

variable "nat_key" {
  type = object({
    key_name   = string
    public_key = string
  })
  description = "NAT Instance Key"
  default = {
    key_name   = "demo_instance_nat"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/1n9Nh0vRBdUec7yEIfD4j6EZS+7MT/7qoRsvKTtE6uxiXXypbYNdjFs6zTXv9ujNPyC15c+DnqPhJxltg2Jk8TGD2WjNIeI4sD6vYp5Eq9QoBgP36xbEI6HjYs3nU0DZFRyXRPdP5byRIN+Ktad37PTJDAf99ohGehcya6vHBj3RQY5e7kWSrUmBAVOsXmKH0oCCs6xnAv41INTePezfUFeuCMHPeRwyjMwRXFTXCWaoJ6Zfu4fA+HUqRV/mHc8+FVrBlrnzadgqBwxIznZwmTUms2TaozkGh7i/c+0AtQok9eY1LhxUTsurCm2e7BhmDv4q2cySjUl73A7832aL kitge@Master"
  }

  sensitive = true
}