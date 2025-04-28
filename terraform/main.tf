terraform {

  required_version = ">= 1.7.0, < 2.0.0"
}

module "aws_infrastructure" {
  count        = var.infrastructure_provider == "aws" ? 1 : 0
  source       = "./modules/aws"
  region       = var.region
  cluster_name = var.cluster_name
}

module "azure_infrastructure" {
  count                 = var.infrastructure_provider == "azure" ? 1 : 0
  source                = "./modules/azure"
  region                = var.region
  cluster_name          = var.cluster_name
  azure_subscription_id = local.azure_config.subscription_id
}

module "on_prem_infrastructure" {
  count        = var.infrastructure_provider == "on-prem" ? 1 : 0
  source       = "./modules/on-prem"
  region       = var.region
  cluster_name = var.cluster_name
}
