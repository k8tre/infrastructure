terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
      configuration_aliases = [
        azurerm.azure-k8sman,
        azurerm.azure-dev,
        azurerm.azure-connectivity,
        azurerm.azure-staging
      ]
    }
  }
  required_version = ">= 1.7.0, < 2.0.0"
}

data "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-kare-con-uks-hub"
  resource_group_name = "rg-kare-con-uks-network"
  provider            = azurerm.azure-connectivity
}

resource "azurerm_private_dns_zone" "pe_private_dns" {
  name                = format("privatelink.%s.azmk8s.io", var.region)
  resource_group_name = "rg-kare-con-uks-dns"
  provider            = azurerm.azure-connectivity
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_link" {
  name                  = "pe_uksouth_link-to-hub"
  resource_group_name   = "rg-kare-con-uks-dns"
  private_dns_zone_name = azurerm_private_dns_zone.pe_private_dns.name
  virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
  provider              = azurerm.azure-connectivity
  registration_enabled  = true
}


module "aks_cluster_environment_dev" {

  source                = "./cluster-environments"
  environment           = "dev"
  service_name          = var.cluster_name
  region                = var.region
  private_dns_zone_id   = azurerm_private_dns_zone.pe_private_dns.id
  private_dns_zone_name = azurerm_private_dns_zone.pe_private_dns.name
  providers = {
    azurerm.azure              = azurerm.azure-dev
    azurerm.azure-connectivity = azurerm.azure-connectivity
  }
}

module "aks_cluster_environment_mgmt" {

  source                = "./cluster-environments"
  environment           = "k8sman"
  service_name          = var.cluster_name
  region                = var.region
  private_dns_zone_id   = azurerm_private_dns_zone.pe_private_dns.id
  private_dns_zone_name = azurerm_private_dns_zone.pe_private_dns.name
  providers = {
    azurerm.azure              = azurerm.azure-k8sman
    azurerm.azure-connectivity = azurerm.azure-connectivity
  }
}

module "aks_cluster_environment_stg" {

  source                = "./cluster-environments"
  environment           = "stg"
  service_name          = var.cluster_name
  region                = var.region
  private_dns_zone_id   = azurerm_private_dns_zone.pe_private_dns.id
  private_dns_zone_name = azurerm_private_dns_zone.pe_private_dns.name
  providers = {
    azurerm.azure              = azurerm.azure-staging
    azurerm.azure-connectivity = azurerm.azure-connectivity
  }
}
