variable "environment" {
  description = "The name of target cluster environment"
  type        = string
}

variable "region" {
  type        = string
  description = "infrastructure region"
}

variable "service_name" {
  type        = string
  description = "Name of the service"
  default     = "k8tre"
}

variable "private_dns_zone_id" {
  type        = string
  description = "private dns id"
}

variable "private_dns_zone_name" {
  type        = string
  description = "private dns name"
}

