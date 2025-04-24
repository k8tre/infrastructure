variable "region" {
    type = string
    description = "infrastructure region"
}

variable "cluster_name" {
    type = string
    description = "Name of the cluster"
    default = "k8tre"
}