variable "resource_group_name" {
  type        = string
  default     = ""
  description = "A container that holds related resources for an Azure solution"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "The ID of the Subnet where this Network Interface should be located in."
}

variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "public_ip_allocation_method" {
  type        = string
  default     = "Static"
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic"
}

variable "public_ip_sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
}

variable "gateway_type" {
  type        = string
  default     = "Vpn"
  description = "The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute"
}

variable "vpn_type" {
  type        = string
  default     = "RouteBased"
  description = "The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased"

}

variable "vpn_gw_sku" {
  type        = string
  default     = "VpnGw1"
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw3, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw3AZ, VpnGw3, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments"
}

variable "vpn_gw_generation" {
  type        = string
  default     = "Generation1"
  description = "The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None"
}

variable "enable_active_active" {
  type        = bool
  default     = false
  description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false."
}

variable "enable_bgp" {
  type        = bool
  default     = false
  description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false"
}

variable "vpn_client_configuration" {
  type        = object({ address_space = string, vpn_client_protocols = list(string), aad_tenant = string, aad_audience = string, aad_issuer = string, vpn_auth_types = list(string) })
  default     = null
  description = "Virtual Network Gateway client configuration to accept IPSec point-to-site connections"
}

variable "local_networks_ipsec_policy" {
  type        = map(string)
  default     = null
  description = "IPSec policy for local networks. Only a single policy can be defined for a connection."
}

variable "vpn_client_configuration_c" {
  type        = object({ address_space = string, vpn_client_protocols = list(string), certificate = string })
  default     = null
  description = "Virtual Network Gateway client configuration to accept IPSec point-to-site connections"
}

variable "local_networks" {
  type        = list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string }))
  default     = []
  description = "List of local virtual network connections to connect to gateway"
}

variable "local_bgp_settings" {
  type        = list(object({ asn_number = number, peering_address = string, peer_weight = number }))
  default     = null
  description = "Local Network Gateway's BGP speaker settings"
}

variable "gateway_connection_type" {
  type        = string
  default     = "IPsec"
  description = "The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet)"
}

variable "express_route_circuit_id" {
  type        = string
  default     = null
  description = "The ID of the Express Route Circuit when creating an ExpressRoute connection"
}

variable "peer_virtual_network_gateway_id" {
  type        = string
  default     = null
  description = "The ID of the peer virtual network gateway when creating a VNet-to-VNet connection"
}

variable "gateway_connection_protocol" {
  description = "The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2"
  default     = "IKEv2"
  type        = string
}

variable "sku" {
  type        = string
  default     = "VpnGw1"
  description = "Configuration of the size and capacity of the virtual network gateway"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = ""
  description = "Terraform current module repo"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "managedby" {
  type        = string
  default     = ""
  description = "ManagedBy, eg ''."
}

variable "vpn_ad" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources."
}

variable "vpn_with_certificate" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources."
}
variable "sts_vpn" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources."
}

#### enable diagnostic setting
variable "log_analytics_destination_type" {
  type        = string
  default     = "AzureDiagnostics"
  description = "Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
}
variable "diagnostic_setting_enable" {
  type    = bool
  default = false
}
variable "log_analytics_workspace_id" {
  type    = string
  default = null
}
variable "storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the Storage Account where logs should be sent."
}
variable "eventhub_name" {
  type        = string
  default     = null
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent."
}
variable "eventhub_authorization_rule_id" {
  type        = string
  default     = null
  description = "Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
}

variable "enable" {
  type        = bool
  default     = true
  description = "Flag to control module creation."
}

variable "metric_enabled" {
  type        = bool
  default     = true
  description = "Whether metric diagnonsis should be enable in diagnostic settings for flexible Mysql."
}

variable "log_category" {
  type        = list(string)
  default     = ["MySqlAuditLogs"]
  description = "Categories of logs to be recorded in diagnostic setting. Acceptable values are MySqlSlowLogs , MySqlAuditLogs "
}
