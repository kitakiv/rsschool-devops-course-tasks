# Terraform AWS Infrastructure

This repository contains Terraform configuration for AWS infrastructure deployment with GitHub Actions CI/CD pipeline.

### Infrastructure Overview

The project uses Terraform v1.12.1 to provision AWS resources with state stored in an S3 bucket. GitHub Actions automates the deployment process through OIDC authentication. This Terraform configuration creates a VPC with multi-AZ deployment across two availability zones in one AWS region.

```
terraform >=  v1.12.1
```

### Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── main.yml      # GitHub Actions workflow
├── provider.tf           # AWS provider and backend configuration
├── main.tf               # Main infrastructure code
├── variables             # Variables for main.tf
└── README.md             # This documentation

```

### CI/CD Pipeline

The GitHub Actions workflow consists of three jobs:

1. terraform-check: Validates the Terraform code

    - Runs ``` terraform fmt -check ```

    - Initializes Terraform

    - Validates configuration

2. terraform-plan: Creates execution plan

    - - Runs ``` terraform plan ```

    - Generates and displays the plan

    - Comments plan results on pull requests

3. terraform-apply: Applies changes

    - Runs ``` terraform apply ```

    - Only runs on pushes to main branch

    - Applies infrastructure changes automatically


### Backend Configuration
The Terraform state is stored in an S3 bucket for state persistence and locking.

### Authentication
GitHub Actions uses OIDC (OpenID Connect) to authenticate with AWS, take the role which is in secrets in my Github

### Usage
1. Clone the repository

2. Configure AWS credentials

3. write your github secrets or replace them with your variables in .github/workflows/main.yml

4. Create pull requests for changes

5. Merge to main branch to trigger deployment

### Infrastructure Components
VPC Configuration
VPC: Single VPC in one AWS region

CIDR Block: 10.0.0.0/16

Availability Zones: 2 AZs (eu-west-1a, eu-west-1b)

Subnet Architecture
Region: eu-west-1
├── AZ: eu-west-1a
│   ├── Public Subnet 1 (10.0.1.0/24)
│   └── Private Subnet 1 (10.0.3.0/24)
└── AZ: eu-west-1b
    ├── Public Subnet 2 (10.0.2.0/24)
    └── Private Subnet 2 (10.0.4.0/24)

Copy
EC2 Instances
4 EC2 instances total:

2 instances in public subnets (one per AZ)

2 instances in private subnets (one per AZ)

Instance Type: t2.micro

AMI: Ubuntu (ami-01f23391a59163da9)

#### Network Connectivity
Internet Gateway: Provides internet access for public subnets

NAT Gateway: Enables outbound internet access for private subnets

#### Route Tables:

Public route table with internet gateway route

Private route table with NAT gateway route

Cross-subnet communication: All subnets can reach each other within the VPC

#### Security
***Security Groups:*** Allow HTTP ***(80)*** and HTTPS ***(443)*** inbound traffic

Network ACLs: Default NACL allows all traffic