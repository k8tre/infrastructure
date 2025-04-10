module "infrastructure" {
  source         = "./modules/base"
  infrastructure_provider = var.infrastructure_provider
  region         = var.region
  cluster_name   = var.cluster_name
  
}