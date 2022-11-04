terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73.0"
    }

    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.3.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_cli_profile
}

# AWS account id
data "aws_caller_identity" "current" {}