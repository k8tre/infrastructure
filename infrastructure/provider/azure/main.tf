terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
  required_version = ">= 1.7.0, < 2.0.0"
}

# Resource Group for AKS
resource "azurerm_resource_group" "aks" {
  name     = format("%s-cluster-rg", var.cluster_name)
  location = "uksouth"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-cluster-vnet", var.cluster_name)
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
}

# Subnet for AKS nodes
resource "azurerm_subnet" "aks_subnet" {
  name                 = format("%s-cluster-subnet", var.cluster_name)
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/16"]
}

# Identity for AKS
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = format("%s-managed-identity", var.cluster_name)
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
}

# AKS prd cluster Verified Module
module "aks_production" {
  source              = "./avm-patterns/avm-ptn-aks-production"
  name                = format("%s-aks-cluster", var.cluster_name)
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  network = {
    name                = azurerm_virtual_network.vnet.name
    resource_group_name = azurerm_resource_group.aks.name
    node_subnet_id      = azurerm_subnet.aks_subnet.id
    pod_cidr            = cidrsubnet(azurerm_virtual_network.vnet.address_space, 8, 1)

  }

  network_policy      = "cilium"
  kubernetes_version  = "1.28.3"
  private_dns_zone_id = null

  managed_identities = {
    user_assigned_resource_ids = azurerm_user_assigned_identity.aks_identity.id
  }

  node_pools = {
    workload = {
      name                 = "workload"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.28"
      min_count            = 2
      max_count            = 3
      os_sku               = "Ubuntu"
      mode                 = "User"
    }
  }

  tags = {
    environment = "production"
    owner       = "k8tre"
  }

}
