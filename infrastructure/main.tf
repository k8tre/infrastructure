terraform {

  required_version = ">= 1.11.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
}

provider "azurerm" {
  alias           = "azure-k8sman"
  subscription_id = var.azure_k8tre_mgmt_cluster_subscription_id
  #tenant_id       = var.azure_tenant_id
  features {}
}

provider "azurerm" {
  alias           = "azure-dev"
  subscription_id = var.azure_k8tre_dev_cluster_subscription_id
  #tenant_id       = var.azure_tenant_id
  features {}
}

provider "azurerm" {
  alias           = "azure-staging"
  subscription_id = var.azure_k8tre_stg_cluster_subscription_id
  #tenant_id       = var.azure_tenant_id
  features {}
}

provider "azurerm" {
  alias           = "azure-connectivity"
  subscription_id = var.azure_k8tre_connectivity_cluster_subscription_id
  #tenant_id       = var.azure_tenant_id
  features {}
}

module "azure_infrastructure" {
  count        = var.infrastructure_provider == "azure" ? 1 : 0
  source       = "./provider/azure/azure"
  region       = var.region
  cluster_name = var.cluster_name
  providers = {
    azurerm.azure-k8sman       = azurerm.azure-k8sman
    azurerm.azure-dev          = azurerm.azure-dev
    azurerm.azure-connectivity = azurerm.azure-connectivity
    azurerm.azure-staging      = azurerm.azure-staging
  }
}

module "aws_infrastructure" {
  count        = var.infrastructure_provider == "aws" ? 1 : 0
  source       = "./provider/aws"
  region       = var.region
  cluster_name = var.cluster_name
}

module "on_prem_infrastructure" {
  count        = var.infrastructure_provider == "on-prem" ? 1 : 0
  source       = "./provider/on-prem"
  region       = var.region
  cluster_name = var.cluster_name
}
