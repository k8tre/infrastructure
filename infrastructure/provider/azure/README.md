<!-- BEGIN_TF_DOCS -->


<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.7.0, < 2.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.26.0)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_subnet.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_user_assigned_identity.aks_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id)

Description: Azure subscription ID

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: infrastructure region

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: Name of the cluster

Type: `string`

Default: `"k8tre"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_aks_production"></a> [aks\_production](#module\_aks\_production)

Source: ../avm-ptn-aks-production

Version:

<!-- END_TF_DOCS -->