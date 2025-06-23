# AWS Infrastructure with Terraform

This repository contains Terraform configuration for a secure AWS infrastructure deployment with GitHub Actions CI/CD pipeline.

## Infrastructure Overview

The infrastructure consists of a VPC with public and private subnets across two availability zones, NAT instance, bastion host, and EC2 instances in both public and private subnets.

```
Terraform >= v1.12.1
```

## Architecture

![Architecture Diagram](https://via.placeholder.com/800x400?text=AWS+Infrastructure+Diagram)

### VPC and Network
- **VPC**: 10.0.0.0/16
- **Region**: eu-west-1
- **Availability Zones**: eu-west-1a, eu-west-1b

### Subnet Layout
- **Public Subnets**:
  - 10.0.1.0/24 (eu-west-1a)
  - 10.0.2.0/24 (eu-west-1b)
- **Private Subnets**:
  - 10.0.3.0/24 (eu-west-1a)
  - 10.0.4.0/24 (eu-west-1b)

### Compute Resources
- **Public EC2 Instances**: One per public subnet
- **Private EC2 Instances**: One per private subnet
- **NAT Instance**: Provides outbound internet access for private subnets
- **Bastion Host**: Secure access point to private instances

### Network Components
- **Internet Gateway**: Provides internet access for public subnets
- **Route Tables**:
  - Public route table with internet gateway route
  - Private route table with NAT instance route

### Security
- **Security Groups**:
  - Public instances: Allow HTTP (80), HTTPS (443), and SSH (22)
  - Private instances: Allow SSH only from bastion host
  - Bastion host: Allow SSH from anywhere
- **Network ACLs**: Default NACL configuration

## Bastion Host

The bastion host provides secure SSH access to instances in private subnets.

## CI/CD Pipeline

GitHub Actions workflow automates the deployment process:

1. **terraform-check**: Validates Terraform code
   - Format check
   - Initialization
   - Validation

2. **terraform-plan**: Creates execution plan
   - Generates plan
   - Comments plan results on pull requests

3. **terraform-apply**: Applies changes
   - Only runs on pushes to main branch
   - Applies infrastructure changes automatically

## State Management

Terraform state is stored in an S3 bucket:
- Bucket: terraform-s3-forbackend
- Key: terraform.tfstate
- Region: eu-west-1

## Authentication

GitHub Actions uses OIDC (OpenID Connect) to authenticate with AWS.

## Usage

1. Clone the repository
2. Configure AWS credentials
3. Set GitHub secrets or replace variables in `.github/workflows/main.yml`
4. Create pull requests for changes
5. Merge to main branch to trigger deployment

## File Structure

```
.
├── .github/workflows/    # GitHub Actions workflow
├── acl_vpc.tf           # Network ACL configuration
├── gateways.tf          # Internet gateway configuration
├── instances.tf         # EC2 instances configuration
├── locals.tf            # Local variables
├── main.tf              # VPC configuration
├── nat-instance.tf      # NAT instance configuration
├── provider.tf          # AWS provider and backend configuration
├── route_table.tf       # Route tables configuration
├── security_groups.tf   # Security groups configuration
├── subnets.tf           # Subnets configuration
└── variables.tf         # Input variables
```
