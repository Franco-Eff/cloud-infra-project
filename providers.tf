# Configures Terraform to use the AWS provider and run remotely via Terraform Cloud
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "francorosito-org"
    workspaces {
      name = "cloud-infra-dev"
    }
  }
}

# Sets the AWS region using the variable defined in variables.tf
provider "aws" {
  region = var.aws_region
}
