# ===== TERRAFORM CONFIGURATION =====
# Terraform Backend & required providers' versions
terraform {
  required_version = ">= 1.8.4"

  cloud {
    hostname     = "app.terraform.io"
    organization = "khahory-organization"

    workspaces {
      tags = [
        "devsu-demo"
      ]
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.7.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}