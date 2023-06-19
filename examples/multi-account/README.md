# Complete AWS Transit Gateway example

Configuration in this directory creates AWS Transit Gateway, attach VPC to it and share it with other AWS principals using [Resource Access Manager (RAM)](https://aws.amazon.com/ram/).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.4 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_peer_hub"></a> [peer\_hub](#module\_peer\_hub) | ../../ | n/a |
| <a name="module_peer_hub_vpc"></a> [peer\_hub\_vpc](#module\_peer\_hub\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |
| <a name="module_peer_spoke"></a> [peer\_spoke](#module\_peer\_spoke) | ../../ | n/a |
| <a name="module_peer_spoke_vpc"></a> [peer\_spoke\_vpc](#module\_peer\_spoke\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |
| <a name="module_primary_hub"></a> [primary\_hub](#module\_primary\_hub) | ../../ | n/a |
| <a name="module_primary_hub_vpc"></a> [primary\_hub\_vpc](#module\_primary\_hub\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |
| <a name="module_primary_spoke"></a> [primary\_spoke](#module\_primary\_spoke) | ../../ | n/a |
| <a name="module_primary_spoke_vpc"></a> [primary\_spoke\_vpc](#module\_primary\_spoke\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peer_hub_ec2_transit_gateway_arn"></a> [peer\_hub\_ec2\_transit\_gateway\_arn](#output\_peer\_hub\_ec2\_transit\_gateway\_arn) | EC2 Transit Gateway Amazon Resource Name (ARN) |
| <a name="output_peer_hub_ec2_transit_gateway_association_default_route_table_id"></a> [peer\_hub\_ec2\_transit\_gateway\_association\_default\_route\_table\_id](#output\_peer\_hub\_ec2\_transit\_gateway\_association\_default\_route\_table\_id) | Identifier of the default association route table |
| <a name="output_peer_hub_ec2_transit_gateway_id"></a> [peer\_hub\_ec2\_transit\_gateway\_id](#output\_peer\_hub\_ec2\_transit\_gateway\_id) | EC2 Transit Gateway identifier |
| <a name="output_peer_hub_ec2_transit_gateway_owner_id"></a> [peer\_hub\_ec2\_transit\_gateway\_owner\_id](#output\_peer\_hub\_ec2\_transit\_gateway\_owner\_id) | Identifier of the AWS account that owns the EC2 Transit Gateway |
| <a name="output_peer_hub_ec2_transit_gateway_propagation_default_route_table_id"></a> [peer\_hub\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id](#output\_peer\_hub\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id) | Identifier of the default propagation route table |
| <a name="output_peer_hub_ec2_transit_gateway_route_ids"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_ids](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_ids) | List of EC2 Transit Gateway Route Table identifier combined with destination |
| <a name="output_peer_hub_ec2_transit_gateway_route_table_association"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_table\_association](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_table\_association) | Map of EC2 Transit Gateway Route Table Association attributes |
| <a name="output_peer_hub_ec2_transit_gateway_route_table_association_ids"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_table\_association\_ids](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_table\_association\_ids) | List of EC2 Transit Gateway Route Table Association identifiers |
| <a name="output_peer_hub_ec2_transit_gateway_route_table_default_association_route_table"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table) | Boolean whether this is the default association route table for the EC2 Transit Gateway |
| <a name="output_peer_hub_ec2_transit_gateway_route_table_default_propagation_route_table"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table) | Boolean whether this is the default propagation route table for the EC2 Transit Gateway |
| <a name="output_peer_hub_ec2_transit_gateway_route_table_id"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_table\_id](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_table\_id) | EC2 Transit Gateway Route Table identifier |
| <a name="output_peer_hub_ec2_transit_gateway_route_table_propagation"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_table\_propagation](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_table\_propagation) | Map of EC2 Transit Gateway Route Table Propagation attributes |
| <a name="output_peer_hub_ec2_transit_gateway_route_table_propagation_ids"></a> [peer\_hub\_ec2\_transit\_gateway\_route\_table\_propagation\_ids](#output\_peer\_hub\_ec2\_transit\_gateway\_route\_table\_propagation\_ids) | List of EC2 Transit Gateway Route Table Propagation identifiers |
| <a name="output_peer_hub_ec2_transit_gateway_vpc_attachment"></a> [peer\_hub\_ec2\_transit\_gateway\_vpc\_attachment](#output\_peer\_hub\_ec2\_transit\_gateway\_vpc\_attachment) | Map of EC2 Transit Gateway VPC Attachment attributes |
| <a name="output_peer_hub_ec2_transit_gateway_vpc_attachment_ids"></a> [peer\_hub\_ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_peer\_hub\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
| <a name="output_peer_hub_ram_principal_association_id"></a> [peer\_hub\_ram\_principal\_association\_id](#output\_peer\_hub\_ram\_principal\_association\_id) | The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma |
| <a name="output_peer_hub_ram_resource_share_id"></a> [peer\_hub\_ram\_resource\_share\_id](#output\_peer\_hub\_ram\_resource\_share\_id) | The Amazon Resource Name (ARN) of the resource share |
| <a name="output_peer_spoke_ec2_transit_gateway_vpc_attachment"></a> [peer\_spoke\_ec2\_transit\_gateway\_vpc\_attachment](#output\_peer\_spoke\_ec2\_transit\_gateway\_vpc\_attachment) | Map of EC2 Transit Gateway VPC Attachment attributes |
| <a name="output_peer_spoke_ec2_transit_gateway_vpc_attachment_ids"></a> [peer\_spoke\_ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_peer\_spoke\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
| <a name="output_primary_hub_ec2_transit_gateway_arn"></a> [primary\_hub\_ec2\_transit\_gateway\_arn](#output\_primary\_hub\_ec2\_transit\_gateway\_arn) | EC2 Transit Gateway Amazon Resource Name (ARN) |
| <a name="output_primary_hub_ec2_transit_gateway_association_default_route_table_id"></a> [primary\_hub\_ec2\_transit\_gateway\_association\_default\_route\_table\_id](#output\_primary\_hub\_ec2\_transit\_gateway\_association\_default\_route\_table\_id) | Identifier of the default association route table |
| <a name="output_primary_hub_ec2_transit_gateway_id"></a> [primary\_hub\_ec2\_transit\_gateway\_id](#output\_primary\_hub\_ec2\_transit\_gateway\_id) | EC2 Transit Gateway identifier |
| <a name="output_primary_hub_ec2_transit_gateway_owner_id"></a> [primary\_hub\_ec2\_transit\_gateway\_owner\_id](#output\_primary\_hub\_ec2\_transit\_gateway\_owner\_id) | Identifier of the AWS account that owns the EC2 Transit Gateway |
| <a name="output_primary_hub_ec2_transit_gateway_propagation_default_route_table_id"></a> [primary\_hub\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id](#output\_primary\_hub\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id) | Identifier of the default propagation route table |
| <a name="output_primary_hub_ec2_transit_gateway_route_ids"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_ids](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_ids) | List of EC2 Transit Gateway Route Table identifier combined with destination |
| <a name="output_primary_hub_ec2_transit_gateway_route_table_association"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_table\_association](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_table\_association) | Map of EC2 Transit Gateway Route Table Association attributes |
| <a name="output_primary_hub_ec2_transit_gateway_route_table_association_ids"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_table\_association\_ids](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_table\_association\_ids) | List of EC2 Transit Gateway Route Table Association identifiers |
| <a name="output_primary_hub_ec2_transit_gateway_route_table_default_association_route_table"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table) | Boolean whether this is the default association route table for the EC2 Transit Gateway |
| <a name="output_primary_hub_ec2_transit_gateway_route_table_default_propagation_route_table"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table) | Boolean whether this is the default propagation route table for the EC2 Transit Gateway |
| <a name="output_primary_hub_ec2_transit_gateway_route_table_id"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_table\_id](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_table\_id) | EC2 Transit Gateway Route Table identifier |
| <a name="output_primary_hub_ec2_transit_gateway_route_table_propagation"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_table\_propagation](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_table\_propagation) | Map of EC2 Transit Gateway Route Table Propagation attributes |
| <a name="output_primary_hub_ec2_transit_gateway_route_table_propagation_ids"></a> [primary\_hub\_ec2\_transit\_gateway\_route\_table\_propagation\_ids](#output\_primary\_hub\_ec2\_transit\_gateway\_route\_table\_propagation\_ids) | List of EC2 Transit Gateway Route Table Propagation identifiers |
| <a name="output_primary_hub_ec2_transit_gateway_vpc_attachment"></a> [primary\_hub\_ec2\_transit\_gateway\_vpc\_attachment](#output\_primary\_hub\_ec2\_transit\_gateway\_vpc\_attachment) | Map of EC2 Transit Gateway VPC Attachment attributes |
| <a name="output_primary_hub_ec2_transit_gateway_vpc_attachment_ids"></a> [primary\_hub\_ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_primary\_hub\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
| <a name="output_primary_hub_ram_principal_association_id"></a> [primary\_hub\_ram\_principal\_association\_id](#output\_primary\_hub\_ram\_principal\_association\_id) | The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma |
| <a name="output_primary_hub_ram_resource_share_id"></a> [primary\_hub\_ram\_resource\_share\_id](#output\_primary\_hub\_ram\_resource\_share\_id) | The Amazon Resource Name (ARN) of the resource share |
| <a name="output_primary_spoke_ec2_transit_gateway_vpc_attachment"></a> [primary\_spoke\_ec2\_transit\_gateway\_vpc\_attachment](#output\_primary\_spoke\_ec2\_transit\_gateway\_vpc\_attachment) | Map of EC2 Transit Gateway VPC Attachment attributes |
| <a name="output_primary_spoke_ec2_transit_gateway_vpc_attachment_ids"></a> [primary\_spoke\_ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_primary\_spoke\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
