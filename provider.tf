terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  backend "s3" {
    bucket       = "terraform-s3-forbackend"
    key          = "terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}