 # Peering Routes Module

 This module is used to manage peering routes.

 ## Usage

 ```hcl
 module "peering_routes" {
  source = "../modules/peering-routes"

  tgw_id = "your_tgw_id"
  cidr_blocks = ["your_cidr_blocks"]
  tgw_peering_tag_name_value = "your_tgw_peering_tag_name_value"
}
 ```

## Inputs

| Name                         | Description                                                                           |      Type      | Default | Required |
| ---------------------------- | ------------------------------------------------------------------------------------- | :------------: | :-----: | :------: |
| `source`                     | The source of the module                                                              |    `string`    |   n/a   |   yes    |
| `tgw_id`                     | The ID of the transit gateway                                                         |    `string`    |   n/a   |   yes    |
| `cidr_blocks`                | A list of CIDR blocks to route                                                        | `list(string)` |   n/a   |   yes    |
| `tgw_peering_tag_name_value` | The value of the Name tag used as a filter for the Transit Gateway Peering Attachment |    `string`    |   n/a   |   yes    |

## Outputs

| Name                          | Description                                 |
| ----------------------------- | ------------------------------------------- |
| `route_table_id`              | The ID of the route table                   |
| `route_ids`                   | The IDs of the TGW routes                   |
| `route_table_association_ids` | The IDs of the TGW route table associations |
