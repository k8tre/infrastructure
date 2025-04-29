<!-- BEGIN_TF_DOCS -->


<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.7.0, < 2.0.0)

## Resources

No resources.

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_infrastructure_provider"></a> [infrastructure\_provider](#input\_infrastructure\_provider)

Description: provider name

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

### <a name="module_aws_infrastructure"></a> [aws\_infrastructure](#module\_aws\_infrastructure)

Source: ./modules/aws

Version:

### <a name="module_azure_infrastructure"></a> [azure\_infrastructure](#module\_azure\_infrastructure)

Source: ./modules/azure

Version:

### <a name="module_on_prem_infrastructure"></a> [on\_prem\_infrastructure](#module\_on\_prem\_infrastructure)

Source: ./modules/on-prem

Version:

<!-- END_TF_DOCS -->