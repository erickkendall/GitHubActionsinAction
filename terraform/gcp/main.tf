# terraform/gcp/main.tf

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  cloud {
    organization = "example-org-8c3d2a"
    
    workspaces {
      name = "gcp-terraform-test"
    }
  }
}

provider "google" {
  project = "terraform-06062025"
  region  = "us-central1"
}

# Test authentication by getting project info
data "google_project" "current" {}
data "google_client_config" "current" {}

# Create a Cloud Storage bucket for testing
resource "google_storage_bucket" "test_bucket" {
  name          = "terraform-test-${random_string.suffix.result}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    environment = "test"
    purpose     = "terraform-cloud-test"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Outputs to verify everything worked
output "project_id" {
  description = "GCP Project ID"
  value       = data.google_project.current.project_id
}

output "project_number" {
  description = "GCP Project Number"
  value       = data.google_project.current.number
}

output "storage_bucket_name" {
  description = "Created Storage Bucket Name"
  value       = google_storage_bucket.test_bucket.name
}

output "storage_bucket_url" {
  description = "Storage Bucket URL"
  value       = google_storage_bucket.test_bucket.url
}
