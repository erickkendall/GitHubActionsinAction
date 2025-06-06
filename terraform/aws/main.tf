# terraform/aws/main.tf

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  cloud {
    organization = "example-org-8c3d2a"
    
    workspaces {
      name = "aws-terraform-test"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Test authentication by getting current AWS identity
data "aws_caller_identity" "current" {}

# Create a simple S3 bucket for testing
resource "aws_s3_bucket" "test_bucket" {
  bucket        = "terraform-aws-test-${random_string.bucket_suffix.result}"
  force_destroy = true
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Outputs to verify everything worked
output "aws_account_id" {
  description = "Current AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_user_id" {
  description = "Current AWS User ID"  
  value       = data.aws_caller_identity.current.user_id
}

output "s3_bucket_name" {
  description = "Created S3 Bucket Name"
  value       = aws_s3_bucket.test_bucket.id
}
