# variable "azure_subscription_id" {
#   description = "Azure subscription ID"
#   type        = string
# }

variable "region" {
  type        = string
  description = "infrastructure region"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "k8tre"
}
