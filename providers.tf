terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "-> 5.0"
        }
    }

    cloud {
        organization = "francorosito-org"
        workspaces {
            name = "cloud-infra-dev"
        }
    }
}

provider "aws" {
    region = var.aws_region
}
