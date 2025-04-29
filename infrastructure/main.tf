terraform {

  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
}

provider "azurerm" {
  alias           = "azure"
  subscription_id = var.azure_subscription_id
  #tenant_id       = var.azure_tenant_id
  features {}
}

module "aws_infrastructure" {
  count        = var.infrastructure_provider == "aws" ? 1 : 0
  source       = "./provider/aws"
  region       = var.region
  cluster_name = var.cluster_name
}

module "azure_infrastructure" {
  count        = var.infrastructure_provider == "azure" ? 1 : 0
  source       = "./provider/azure"
  region       = var.region
  cluster_name = var.cluster_name
  providers = {
    azurerm = azurerm.azure
  }
}

module "on_prem_infrastructure" {
  count        = var.infrastructure_provider == "on-prem" ? 1 : 0
  source       = "./provider/on-prem"
  region       = var.region
  cluster_name = var.cluster_name
}
