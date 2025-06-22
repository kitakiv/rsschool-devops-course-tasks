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
    instance_tags = object({
      Name = string
    })
    instance_profile = string
  })
  description = "EC2 Instance Settings"
  default = {
    ami           = "ami-000d51c6fbd4cec95"
    instance_type = "t2.micro"
    instance_tags = {
      Name = "EC2 Instance"
    }
    instance_profile = "ec2_instance_profile"
  }
}
