# acme-brick

This terraform stack represents the initial VPC networking, compute, database, storage, and security components of an AWS account configured for Acme Bricks.  More components can be added (or removed) on a per account basis depending on the purpose of the account.

The proposal documentation is located in ```acme_bricks_proposal.pdf```.

The AWS Account Diagram is located in ```acme_bricks_diagram.pdf```.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ci_cd"></a> [ci\_cd](#module\_ci\_cd) | ./modules/ci_cd | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./modules/compute/ec2 | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ./modules/compute/ecs | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ./modules/compute/lambda | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS CLI profile to use | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The password for the database | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment (e.g., dev, staging, prod) | `string` | `"prod"` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | The GitHub repository to use for the CodePipeline | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | `"acme-brick"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |