<!-- BEGIN_TF_DOCS -->
# AWS GWLB Centralized Architecture with Transit Gateway setup

## Overview

Using this Terraform template following resources will be created:

- Mgmt, Diag, Outside, Inside subnets per AZ in the service VPC
- One Gateway Load balancer
- 2 Cisco Secure Firewall Threat Defense (FTD) in service VPC as GWLB Targets
- One Transit Gateway
- Attachments for Transit Gateway to service and spoke vpc
- One TGW subnet per AZ in service VPC
- Default route in Service TGW subnet to Gateway Load balancer Endpoint
- Default route in Spoke TGW Subnet to TGW
- Transit Gateway Routing table for each attachements
- Gateway Load balancer Endpoint(GWLBE) subnets per AZ in service VPC
- NAT gateway subnets per AZ in service VPC
- NAT Gateway per AZ in Service VPC
- Default route in GWLBE subnets to NAT Gateway
- Spoke VPC subnet route in GWLBE to Transit Gateway
- Default route in NAT gateway subnets to Internet Gateway

*Appliance mode is enabled for service VPC Transit Gateway Attachment*

## Topology

<p align="center">
  <img src="https://github.com/sameesin/terraform-cisco-secure-firewall/blob/modules/images/centralized_architecture.png" width="100%">
</p>

## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Programmatic access to AWS account with CLI - learn how to set up [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

- Service VPC with a subnet created
- A Cisco Secure Firewall Management Center (FMC) in Service VPC with security groups attached allowing HTTPS traffic and traffic from Cisco Secure Firewall Threat Defense.
- Spoke VPC with one subnet per AZ and routing table assosciated to the subnets

## Test Setup

- Add a test machine in the spoke TGW subnet
- Add an access rule in the created ACP (GWLB-ACP) to allow the test traffic

The template has been tested on :
- Terraform = v1.0.11

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement\_terraform"></a> [terraform](#requirement\\_terraform) | >= 0.13.5 |
| <a name="requirement\_aws"></a> [aws](#requirement\\_aws) | >= 2.7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module\_gwlb"></a> [gwlb](#module\\_gwlb) | ../../modules/gwlb | n/a |
| <a name="module\_gwlbe"></a> [gwlbe](#module\\_gwlbe) | ../../modules/gwlbe | n/a |
| <a name="module\_instance"></a> [instance](#module\\_instance) | ../../modules/firewallserver | n/a |
| <a name="module\_nat\_gw"></a> [nat\\_gw](#module\\_nat\\_gw) | ../../modules/nat\_gw | n/a |
| <a name="module\_service\_network"></a> [service\\_network](#module\\_service\\_network) | ../../modules/network | n/a |
| <a name="module\_spoke\_network"></a> [spoke\\_network](#module\\_spoke\\_network) | ../../modules/network | n/a |
| <a name="module\_transitgateway"></a> [transitgateway](#module\\_transitgateway) | ../../modules/transitgateway | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input\_aws\_access\_key"></a> [aws\\_access\\_key](#input\\_aws\\_access\\_key) | AWS ACCESS KEY | `string` | n/a | yes |
| <a name="input\_aws\_secret\_key"></a> [aws\\_secret\\_key](#input\\_aws\\_secret\\_key) | AWS SECRET KEY | `string` | n/a | yes |
| <a name="input\_gwlb\_name"></a> [gwlb\\_name](#input\\_gwlb\\_name) | name for Gateway loadbalancer | `string` | n/a | yes |
| <a name="input\_keyname"></a> [keyname](#input\\_keyname) | key to be used for the instances | `string` | n/a | yes |
| <a name="input\_availability\_zone\_count"></a> [availability\\_zone\\_count](#input\\_availability\\_zone\\_count) | Spacified availablity zone count . | `number` | `2` | no |
| <a name="input\_diag\_subnet\_cidr"></a> [diag\\_subnet\\_cidr](#input\\_diag\\_subnet\\_cidr) | List out diagonastic Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input\_diag\_subnet\_name"></a> [diag\\_subnet\\_name](#input\\_diag\\_subnet\\_name) | Specified diagonstic subnet names | `list(string)` | `[]` | no |
| <a name="input\_fmc\_ip"></a> [fmc\\_ip](#input\\_fmc\\_ip) | List out FMCv IPs . | `string` | `""` | no |
| <a name="input\_fmc\_mgmt\_interface\_sg"></a> [fmc\\_mgmt\\_interface\\_sg](#input\\_fmc\\_mgmt\\_interface\\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from\_port   = number<br>    protocol    = string<br>    to\_port     = number<br>    cidr\_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr\_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from\_port": 0,<br>    "protocol": "-1",<br>    "to\_port": 0<br>  }<br>]</pre> | no |
| <a name="input\_ftd\_diag\_ip"></a> [ftd\\_diag\\_ip](#input\\_ftd\\_diag\\_ip) | List out FTD Diagonostic IPs . | `list(string)` | `[]` | no |
| <a name="input\_ftd\_inside\_ip"></a> [ftd\\_inside\\_ip](#input\\_ftd\\_inside\\_ip) | List FTD inside IPs . | `list(string)` | `[]` | no |
| <a name="input\_ftd\_mgmt\_ip"></a> [ftd\\_mgmt\\_ip](#input\\_ftd\\_mgmt\\_ip) | List out management IPs . | `list(string)` | `[]` | no |
| <a name="input\_ftd\_outside\_ip"></a> [ftd\\_outside\\_ip](#input\\_ftd\\_outside\\_ip) | List outside IPs . | `list(string)` | `[]` | no |
| <a name="input\_ftd\_size"></a> [ftd\\_size](#input\\_ftd\\_size) | FTD Instance Size | `string` | `"c5.xlarge"` | no |
| <a name="input\_gwlbe\_subnet\_cidr"></a> [gwlbe\\_subnet\\_cidr](#input\\_gwlbe\\_subnet\\_cidr) | List out GWLBE Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input\_gwlbe\_subnet\_name"></a> [gwlbe\\_subnet\\_name](#input\\_gwlbe\\_subnet\\_name) | List out GWLBE Subnet names . | `list(string)` | `[]` | no |
| <a name="input\_inside\_interface\_sg"></a> [inside\\_interface\\_sg](#input\\_inside\\_interface\\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from\_port   = number<br>    protocol    = string<br>    to\_port     = number<br>    cidr\_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr\_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from\_port": 0,<br>    "protocol": "-1",<br>    "to\_port": 0<br>  }<br>]</pre> | no |
| <a name="input\_inside\_subnet\_cidr"></a> [inside\\_subnet\\_cidr](#input\\_inside\\_subnet\\_cidr) | List out inside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input\_inside\_subnet\_name"></a> [inside\\_subnet\\_name](#input\\_inside\\_subnet\\_name) | Specified inside subnet names | `list(string)` | `[]` | no |
| <a name="input\_instances\_per\_az"></a> [instances\\_per\\_az](#input\\_instances\\_per\\_az) | Spacified no. of instance per az wants to be create . | `number` | `1` | no |
| <a name="input\_mgmt\_interface\_sg"></a> [mgmt\\_interface\\_sg](#input\\_mgmt\\_interface\\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from\_port   = number<br>    protocol    = string<br>    to\_port     = number<br>    cidr\_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr\_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from\_port": 0,<br>    "protocol": "-1",<br>    "to\_port": 0<br>  }<br>]</pre> | no |
| <a name="input\_mgmt\_subnet\_cidr"></a> [mgmt\\_subnet\\_cidr](#input\\_mgmt\\_subnet\\_cidr) | List out management Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input\_mgmt\_subnet\_name"></a> [mgmt\\_subnet\\_name](#input\\_mgmt\\_subnet\\_name) | Specified management subnet names | `list(string)` | `[]` | no |
| <a name="input\_ngw\_subnet\_cidr"></a> [ngw\\_subnet\\_cidr](#input\\_ngw\\_subnet\\_cidr) | List out NGW Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input\_ngw\_subnet\_name"></a> [ngw\\_subnet\\_name](#input\\_ngw\\_subnet\\_name) | List out NGW Subnet names . | `list(string)` | `[]` | no |
| <a name="input\_outside\_interface\_sg"></a> [outside\\_interface\\_sg](#input\\_outside\\_interface\\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from\_port   = number<br>    protocol    = string<br>    to\_port     = number<br>    cidr\_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr\_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from\_port": 0,<br>    "protocol": "-1",<br>    "to\_port": 0<br>  }<br>]</pre> | no |
| <a name="input\_outside\_subnet\_cidr"></a> [outside\\_subnet\\_cidr](#input\\_outside\\_subnet\\_cidr) | List out outside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input\_outside\_subnet\_name"></a> [outside\\_subnet\\_name](#input\\_outside\\_subnet\\_name) | Specified outside subnet names | `list(string)` | `[]` | no |
| <a name="input\_region"></a> [region](#input\\_region) | AWS REGION | `string` | `"us-east-1"` | no |
| <a name="input\_service\_create\_igw"></a> [service\\_create\\_igw](#input\\_service\\_create\\_igw) | Boolean value to decide if to create IGW or not | `bool` | `false` | no |
| <a name="input\_service\_vpc\_cidr"></a> [service\\_vpc\\_cidr](#input\\_service\\_vpc\\_cidr) | Service VPC CIDR | `string` | `null` | no |
| <a name="input\_service\_vpc\_name"></a> [service\\_vpc\\_name](#input\\_service\\_vpc\\_name) | Service VPC Name | `string` | `null` | no |
| <a name="input\_spoke\_create\_igw"></a> [spoke\\_create\\_igw](#input\\_spoke\\_create\\_igw) | Condition to create IGW . | `string` | `true` | no |
| <a name="input\_spoke\_subnet\_cidr"></a> [spoke\\_subnet\\_cidr](#input\\_spoke\\_subnet\\_cidr) | List out spoke Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input\_spoke\_subnet\_name"></a> [spoke\\_subnet\\_name](#input\\_spoke\\_subnet\\_name) | List out spoke Subnet names . | `list(string)` | `[]` | no |
| <a name="input\_spoke\_vpc\_cidr"></a> [spoke\\_vpc\\_cidr](#input\\_spoke\\_vpc\\_cidr) | Specified CIDR for VPC . | `string` | `null` | no |
| <a name="input\_spoke\_vpc\_name"></a> [spoke\\_vpc\\_name](#input\\_spoke\\_vpc\\_name) | Specified VPC Name . | `string` | `null` | no |
| <a name="input\_tgw\_subnet\_cidr"></a> [tgw\\_subnet\\_cidr](#input\\_tgw\\_subnet\\_cidr) | List of Transit GW Subnet CIDR | `list(string)` | `[]` | no |
| <a name="input\_tgw\_subnet\_name"></a> [tgw\\_subnet\\_name](#input\\_tgw\\_subnet\\_name) | List of name for TGW Subnets | `list(string)` | `[]` | no |
| <a name="input\_transit\_gateway\_name"></a> [transit\\_gateway\\_name](#input\\_transit\\_gateway\\_name) | Name of the Transit Gateway created | `string` | `null` | no |
| <a name="input\_use\_fmc\_eip"></a> [use\\_fmc\\_eip](#input\\_use\\_fmc\\_eip) | boolean value to use EIP on FMC or not | `bool` | `false` | no |
| <a name="input\_use\_ftd\_eip"></a> [use\\_ftd\\_eip](#input\\_use\\_ftd\\_eip) | boolean value to use EIP on FTD or not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output\_instance\_ip"></a> [instance\\_ip](#output\\_instance\\_ip) | Public IP address of the FTD instances |

* User will need to add route to spoke subnet in the NAT GATEWAY and GWLBE subnets

### To use aws secret manager to store sensitive information used in this plan
```cli
aws secretsmanager create-secret --name secret-name --secret-string "{\"aws_access_key\":\"AWS_ACCESS_KEY\"}"
```

To use the secret created above in the plan

```terraform
data "aws_secretsmanager_secret" "secrets" {
  name = "secret-name"
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

locals {
  secret = jsondecode(
    data.aws_secretsmanager_secret_version.secret_version.secret_string
  )
}

provider "aws" {
...
  access_key = locals.secret.aws_access_key
...
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.7.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gwlb"></a> [gwlb](#module\_gwlb) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/gwlb | n/a |
| <a name="module_gwlbe"></a> [gwlbe](#module\_gwlbe) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/gwlbe | n/a |
| <a name="module_instance"></a> [instance](#module\_instance) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/firewall_instance | n/a |
| <a name="module_nat_gw"></a> [nat\_gw](#module\_nat\_gw) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/nat_gw | n/a |
| <a name="module_service_network"></a> [service\_network](#module\_service\_network) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/network | n/a |
| <a name="module_spoke_network"></a> [spoke\_network](#module\_spoke\_network) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/network | n/a |
| <a name="module_transitgateway"></a> [transitgateway](#module\_transitgateway) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/transitgateway | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.lambda_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_security_group.sg_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [time_sleep.wait_720_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_lambda_invocation.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_invocation) | data source |
| [aws_vpc.ftd_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS ACCESS KEY | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS SECRET KEY | `string` | n/a | yes |
| <a name="input_fmc_password"></a> [fmc\_password](#input\_fmc\_password) | n/a | `string` | n/a | yes |
| <a name="input_fmc_username"></a> [fmc\_username](#input\_fmc\_username) | n/a | `string` | n/a | yes |
| <a name="input_ftd_inside_gw"></a> [ftd\_inside\_gw](#input\_ftd\_inside\_gw) | Inside subnet Gateway | `list(string)` | n/a | yes |
| <a name="input_gwlb_name"></a> [gwlb\_name](#input\_gwlb\_name) | name for Gateway loadbalancer | `string` | n/a | yes |
| <a name="input_keyname"></a> [keyname](#input\_keyname) | key to be used for the instances | `string` | n/a | yes |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Spacified availablity zone count . | `number` | `2` | no |
| <a name="input_create_fmc"></a> [create\_fmc](#input\_create\_fmc) | Boolean value to create FMC or not | `bool` | `true` | no |
| <a name="input_create_tgw"></a> [create\_tgw](#input\_create\_tgw) | n/a | `bool` | `true` | no |
| <a name="input_diag_subnet_cidr"></a> [diag\_subnet\_cidr](#input\_diag\_subnet\_cidr) | List out diagonastic Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_diag_subnet_name"></a> [diag\_subnet\_name](#input\_diag\_subnet\_name) | Specified diagonstic subnet names | `list(string)` | `[]` | no |
| <a name="input_fmc_ip"></a> [fmc\_ip](#input\_fmc\_ip) | List out FMCv IPs . | `string` | `""` | no |
| <a name="input_fmc_mgmt_interface_sg"></a> [fmc\_mgmt\_interface\_sg](#input\_fmc\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "FMC Mgmt Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_fmc_version"></a> [fmc\_version](#input\_fmc\_version) | n/a | `string` | `"fmcv-7.3.0"` | no |
| <a name="input_ftd_diag_ip"></a> [ftd\_diag\_ip](#input\_ftd\_diag\_ip) | List out FTD Diagonostic IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_inside_ip"></a> [ftd\_inside\_ip](#input\_ftd\_inside\_ip) | List FTD inside IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_mgmt_ip"></a> [ftd\_mgmt\_ip](#input\_ftd\_mgmt\_ip) | List out management IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_outside_ip"></a> [ftd\_outside\_ip](#input\_ftd\_outside\_ip) | List outside IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_size"></a> [ftd\_size](#input\_ftd\_size) | FTD Instance Size | `string` | `"c5.xlarge"` | no |
| <a name="input_ftd_version"></a> [ftd\_version](#input\_ftd\_version) | n/a | `string` | `"ftdv-7.3.0"` | no |
| <a name="input_gwlbe_subnet_cidr"></a> [gwlbe\_subnet\_cidr](#input\_gwlbe\_subnet\_cidr) | List out GWLBE Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_gwlbe_subnet_name"></a> [gwlbe\_subnet\_name](#input\_gwlbe\_subnet\_name) | List out GWLBE Subnet names . | `list(string)` | `[]` | no |
| <a name="input_inside_interface_sg"></a> [inside\_interface\_sg](#input\_inside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Inside Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_inside_subnet_cidr"></a> [inside\_subnet\_cidr](#input\_inside\_subnet\_cidr) | List out inside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_inside_subnet_name"></a> [inside\_subnet\_name](#input\_inside\_subnet\_name) | Specified inside subnet names | `list(string)` | `[]` | no |
| <a name="input_instances_per_az"></a> [instances\_per\_az](#input\_instances\_per\_az) | Spacified no. of instance per az wants to be create . | `number` | `1` | no |
| <a name="input_lambda_func_name"></a> [lambda\_func\_name](#input\_lambda\_func\_name) | n/a | `string` | `"fmc_config_func"` | no |
| <a name="input_lambda_subnet_cidr"></a> [lambda\_subnet\_cidr](#input\_lambda\_subnet\_cidr) | Lambda Subnet CIDR | `string` | `""` | no |
| <a name="input_lambda_subnet_name"></a> [lambda\_subnet\_name](#input\_lambda\_subnet\_name) | Name for Lambda Subnet | `string` | `""` | no |
| <a name="input_mgmt_interface_sg"></a> [mgmt\_interface\_sg](#input\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Mgmt Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_mgmt_subnet_cidr"></a> [mgmt\_subnet\_cidr](#input\_mgmt\_subnet\_cidr) | List out management Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_mgmt_subnet_name"></a> [mgmt\_subnet\_name](#input\_mgmt\_subnet\_name) | Specified management subnet names | `list(string)` | `[]` | no |
| <a name="input_ngw_subnet_cidr"></a> [ngw\_subnet\_cidr](#input\_ngw\_subnet\_cidr) | List out NGW Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_ngw_subnet_name"></a> [ngw\_subnet\_name](#input\_ngw\_subnet\_name) | List out NGW Subnet names . | `list(string)` | `[]` | no |
| <a name="input_outside_interface_sg"></a> [outside\_interface\_sg](#input\_outside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Outside Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_outside_subnet_cidr"></a> [outside\_subnet\_cidr](#input\_outside\_subnet\_cidr) | List out outside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_outside_subnet_name"></a> [outside\_subnet\_name](#input\_outside\_subnet\_name) | Specified outside subnet names | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS REGION | `string` | `"us-east-1"` | no |
| <a name="input_service_create_igw"></a> [service\_create\_igw](#input\_service\_create\_igw) | Boolean value to decide if to create IGW or not | `bool` | `false` | no |
| <a name="input_service_igw_name"></a> [service\_igw\_name](#input\_service\_igw\_name) | name of existing IGW to be used | `string` | `""` | no |
| <a name="input_service_vpc_cidr"></a> [service\_vpc\_cidr](#input\_service\_vpc\_cidr) | Service VPC CIDR | `string` | `null` | no |
| <a name="input_service_vpc_name"></a> [service\_vpc\_name](#input\_service\_vpc\_name) | Service VPC Name | `string` | `null` | no |
| <a name="input_spoke_create_igw"></a> [spoke\_create\_igw](#input\_spoke\_create\_igw) | Condition to create IGW . | `bool` | `true` | no |
| <a name="input_spoke_igw_name"></a> [spoke\_igw\_name](#input\_spoke\_igw\_name) | name of existing IGW to be used | `string` | `""` | no |
| <a name="input_spoke_subnet_cidr"></a> [spoke\_subnet\_cidr](#input\_spoke\_subnet\_cidr) | List out spoke Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_spoke_subnet_name"></a> [spoke\_subnet\_name](#input\_spoke\_subnet\_name) | List out spoke Subnet names . | `list(string)` | `[]` | no |
| <a name="input_spoke_vpc_cidr"></a> [spoke\_vpc\_cidr](#input\_spoke\_vpc\_cidr) | Specified CIDR for VPC . | `string` | `null` | no |
| <a name="input_spoke_vpc_name"></a> [spoke\_vpc\_name](#input\_spoke\_vpc\_name) | Specified VPC Name . | `string` | `null` | no |
| <a name="input_tgw_subnet_cidr"></a> [tgw\_subnet\_cidr](#input\_tgw\_subnet\_cidr) | List of Transit GW Subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_name"></a> [tgw\_subnet\_name](#input\_tgw\_subnet\_name) | List of name for TGW Subnets | `list(string)` | `[]` | no |
| <a name="input_transit_gateway_name"></a> [transit\_gateway\_name](#input\_transit\_gateway\_name) | Name of the Transit Gateway created | `string` | `null` | no |
| <a name="input_use_fmc_eip"></a> [use\_fmc\_eip](#input\_use\_fmc\_eip) | boolean value to use EIP on FMC or not | `bool` | `false` | no |
| <a name="input_use_ftd_eip"></a> [use\_ftd\_eip](#input\_use\_ftd\_eip) | boolean value to use EIP on FTD or not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ip"></a> [instance\_ip](#output\_instance\_ip) | Public IP address of the FTD instances |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | Internet Gateway ID |
<!-- END_TF_DOCS -->
