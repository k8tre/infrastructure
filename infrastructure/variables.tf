variable "infrastructure_provider" {
  type        = string
  description = "provider name"
}

variable "region" {
  type        = string
  description = "infrastructure region"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "k8tre"
}

# Conditional Az vars
variable "azure_k8tre_mgmt_cluster_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = null

  validation {
    condition     = var.infrastructure_provider != "azure" || var.azure_k8tre_mgmt_cluster_subscription_id != null
    error_message = "azure_k8tre_mgmt_cluster_subscription_id must be set when infrastructure_provider is 'azure'."
  }
}

variable "azure_k8tre_dev_cluster_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = null

  validation {
    condition     = var.infrastructure_provider != "azure" || var.azure_k8tre_dev_cluster_subscription_id != null
    error_message = "azure_k8tre_dev_cluster_subscription_id must be set when infrastructure_provider is 'azure'."
  }
}

variable "azure_k8tre_stg_cluster_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = null

  validation {
    condition     = var.infrastructure_provider != "azure" || var.azure_k8tre_stg_cluster_subscription_id != null
    error_message = "azure_k8tre_dev_cluster_subscription_id must be set when infrastructure_provider is 'azure'."
  }
}

variable "azure_k8tre_connectivity_cluster_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = null

  validation {
    condition     = var.infrastructure_provider != "azure" || var.azure_k8tre_connectivity_cluster_subscription_id != null
    error_message = "azure_k8tre_connectivity_cluster_subscription_id must be set when infrastructure_provider is 'azure'."
  }
}

variable "azure_k8tre_mgmt_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = null

  validation {
    condition     = var.infrastructure_provider != "azure" || var.azure_k8tre_mgmt_subscription_id != null
    error_message = "azure_k8tre_mgmt_subscription_id must be set when infrastructure_provider is 'azure'."
  }
}


variable "azure_tenant_id" {
  type        = string
  description = "Azure subscription ID"
  default     = null

  validation {
    condition     = var.infrastructure_provider != "azure" || var.azure_tenant_id != null
    error_message = "azure_tenant_id must be set when infrastructure_provider is 'azure'."
  }
}

# Conditional AWS vars


