# Terraform AWS Infrastructure

This repository contains Terraform configuration for AWS infrastructure deployment with GitHub Actions CI/CD pipeline.

### Infrastructure Overview

The project uses Terraform v1.12.1 to provision AWS resources with state stored in an S3 bucket. GitHub Actions automates the deployment process through OIDC authentication.

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