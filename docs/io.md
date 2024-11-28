## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| diagnostic\_setting\_enable | n/a | `bool` | `false` | no |
| enable | Flag to control module creation. | `bool` | `true` | no |
| enable\_active\_active | If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false. | `bool` | `false` | no |
| enable\_bgp | If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false | `bool` | `false` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| eventhub\_authorization\_rule\_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | `string` | `null` | no |
| eventhub\_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. | `string` | `null` | no |
| express\_route\_circuit\_id | The ID of the Express Route Circuit when creating an ExpressRoute connection | `string` | `null` | no |
| gateway\_connection\_protocol | The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2 | `string` | `"IKEv2"` | no |
| gateway\_connection\_type | The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet) | `string` | `"IPsec"` | no |
| gateway\_type | The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute | `string` | `"Vpn"` | no |
| label\_order | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| local\_bgp\_settings | Local Network Gateway's BGP speaker settings | `list(object({ asn_number = number, peering_address = string, peer_weight = number }))` | `null` | no |
| local\_networks | List of local virtual network connections to connect to gateway | `list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string }))` | `[]` | no |
| local\_networks\_ipsec\_policy | IPSec policy for local networks. Only a single policy can be defined for a connection. | `map(string)` | `null` | no |
| log\_analytics\_destination\_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| log\_analytics\_workspace\_id | n/a | `string` | `null` | no |
| log\_category | Categories of logs to be recorded in diagnostic setting. Acceptable values are MySqlSlowLogs , MySqlAuditLogs | `list(string)` | <pre>[<br>  "MySqlAuditLogs"<br>]</pre> | no |
| managedby | ManagedBy, eg ''. | `string` | `""` | no |
| metric\_enabled | Whether metric diagnonsis should be enable in diagnostic settings for flexible Mysql. | `bool` | `true` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| peer\_virtual\_network\_gateway\_id | The ID of the peer virtual network gateway when creating a VNet-to-VNet connection | `string` | `null` | no |
| public\_ip\_allocation\_method | Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic | `string` | `"Static"` | no |
| public\_ip\_sku | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic | `string` | `"Standard"` | no |
| repository | Terraform current module repo | `string` | `""` | no |
| resource\_group\_name | A container that holds related resources for an Azure solution | `string` | `""` | no |
| sku | Configuration of the size and capacity of the virtual network gateway | `string` | `"VpnGw1"` | no |
| storage\_account\_id | The ID of the Storage Account where logs should be sent. | `string` | `null` | no |
| sts\_vpn | Set to false to prevent the module from creating any resources. | `bool` | `false` | no |
| subnet\_id | The ID of the Subnet where this Network Interface should be located in. | `string` | `""` | no |
| vpn\_ad | Set to false to prevent the module from creating any resources. | `bool` | `false` | no |
| vpn\_client\_configuration | Virtual Network Gateway client configuration to accept IPSec point-to-site connections | `object({ address_space = string, vpn_client_protocols = list(string), aad_tenant = string, aad_audience = string, aad_issuer = string, vpn_auth_types = list(string) })` | `null` | no |
| vpn\_client\_configuration\_c | Virtual Network Gateway client configuration to accept IPSec point-to-site connections | `object({ address_space = string, vpn_client_protocols = list(string), certificate = string })` | `null` | no |
| vpn\_gw\_generation | The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None | `string` | `"Generation1"` | no |
| vpn\_gw\_sku | Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw3, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw3AZ, VpnGw3, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn\_type and generation arguments | `string` | `"VpnGw1"` | no |
| vpn\_type | The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased | `string` | `"RouteBased"` | no |
| vpn\_with\_certificate | Set to false to prevent the module from creating any resources. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| local\_network\_gw\_connection\_id | The ID of the Virtual Network Gateway Connection. |
| local\_network\_gw\_id | The ID of the Local Network Gateway. |
| vpn\_gw\_id | The ID of the Virtual Network Gateway. |
| vpn\_gw\_id\_certificate | The ID of the Virtual Network Gateway. |

