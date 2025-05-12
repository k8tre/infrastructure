terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
      configuration_aliases = [
        azurerm.azure,
        azurerm.azure-connectivity
      ]
    }
  }
  required_version = ">= 1.7.0, < 2.0.0"
}

#
# k8s private aks cluster
#

resource "azurerm_resource_group" "cluster_rg" {
  name     = format("rg-%s-%s-uks-aks", var.service_name, var.environment)
  location = var.region
  provider = azurerm.azure

  tags = {
    Service        = "AKS Cluster"
    ServiceName    = var.service_name
    "Service Name" = var.service_name

    "Service Owner" = "s-m.harding"
    ServiceOwner    = "s-m.harding"

    "Cost Centre" = "ICT"
    CostCentre    = "ICT"
    Environment   = var.environment
  }
}

data "azurerm_virtual_network" "cluster_spoke_vnet" {
  name                = format("vnet-kare-%s-uks-spoke", var.environment)
  resource_group_name = format("rg-kare-%s-uks-network", var.environment)
  provider            = azurerm.azure
}


data "azurerm_subnet" "cluster_spoke_aks_node_subnet" {
  name                 = "snet-clusternodes"
  virtual_network_name = data.azurerm_virtual_network.cluster_spoke_vnet.name
  resource_group_name  = data.azurerm_virtual_network.cluster_spoke_vnet.resource_group_name
  provider             = azurerm.azure
}

# Identity for AKS
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = format("managed-id-%s-%s-cluster", var.service_name, var.environment)
  resource_group_name = azurerm_resource_group.cluster_rg.name
  location            = azurerm_resource_group.cluster_rg.location
  provider            = azurerm.azure
}

# AKS prd cluster Verified Module
module "aks_cluster" {
  source              = "../avm-patterns/avm-ptn-aks-production"
  name                = format("%s-%s-cluster", var.service_name, var.environment)
  location            = azurerm_resource_group.cluster_rg.location
  resource_group_name = azurerm_resource_group.cluster_rg.name

  providers = {
    azurerm = azurerm.azure
  }

  network = {
    name                = data.azurerm_virtual_network.cluster_spoke_vnet.name
    resource_group_name = data.azurerm_virtual_network.cluster_spoke_vnet.resource_group_name
    node_subnet_id      = data.azurerm_subnet.cluster_spoke_aks_node_subnet.id
    pod_cidr            = "10.2.0.0/16" # cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 2)

  }

  network_policy              = "cilium"
  kubernetes_version          = "1.32"
  private_dns_zone_id         = var.private_dns_zone_id # azurerm_private_dns_zone.aks_private_dns.id
  private_dns_zone_id_enabled = true

  rbac_aad_admin_group_object_ids = ["a81dd15a-b8f2-4ae6-b5fb-d2cd0fbd54ab"]

  managed_identities = {
    user_assigned_resource_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  node_pools = {
    workload = {
      name                    = "workload"
      vm_size                 = "Standard_D2d_v5"
      orchestrator_version    = "1.32"
      min_count               = 1
      max_count               = 1
      os_sku                  = "Ubuntu"
      mode                    = "User"
      host_encryption_enabled = false
    }
  }

  tags = {
    environment = var.environment
    owner       = var.service_name
  }

}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke_link" {
  name                  = format("%s-aks-pe-link-to-spoke", var.environment)
  resource_group_name   = "rg-kare-con-uks-dns"
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = data.azurerm_virtual_network.cluster_spoke_vnet.id
  registration_enabled  = true
  provider              = azurerm.azure-connectivity
}
