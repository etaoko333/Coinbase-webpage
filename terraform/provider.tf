terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0" # Optional, but good to specify the minimum Terraform version
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}