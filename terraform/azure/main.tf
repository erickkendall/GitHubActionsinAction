# terraform/azure/main.tf

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  cloud {
    organization = "example-org-8c3d2a"
    
    workspaces {
      name = "azure-terraform-test"
    }
  }
}

provider "azurerm" {
  features {}
}

# Test authentication by getting current client info
data "azurerm_client_config" "current" {}

# Create a resource group
resource "azurerm_resource_group" "test_rg" {
  name     = "terraform-test-${random_string.suffix.result}-rg"
  location = "East US"

  tags = {
    Environment = "test"
    Purpose     = "Terraform Cloud Test"
  }
}

# Create a storage account for testing
resource "azurerm_storage_account" "test_storage" {
  name                     = "terraformtest${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.test_rg.name
  location                 = azurerm_resource_group.test_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "test"
    Purpose     = "Terraform Cloud Test"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

# Outputs to verify everything worked
output "subscription_id" {
  description = "Azure Subscription ID"
  value       = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
  description = "Azure Tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "resource_group_name" {
  description = "Created Resource Group Name"
  value       = azurerm_resource_group.test_rg.name
}

output "storage_account_name" {
  description = "Created Storage Account Name"
  value       = azurerm_storage_account.test_storage.name
}
