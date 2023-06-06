variable "resource_group_name" {
  type        = string
  default     = ""
  description = "A container that holds related resources for an Azure solution"
}

variable "location" {
  type        = string
  default     = ""
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"

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

variable "vpn_gateway_name" {
  type        = string
  default     = ""
  description = "The name of the Virtual Network Gateway"

}

variable "public_ip_allocation_method" {
  type        = string
  default     = "Dynamic"
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic"

}

variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  default     = "Basic"
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
  default     = "VpnGw3"
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw3, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw3AZ, VpnGw3, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments"
}

variable "expressroute_sku" {
  type        = string
  default     = "Standard"
  description = "Configuration of the size and capacity of the virtual network gateway for ExpressRoute type. Valid options are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ and depend on the type, vpn_type and generation arguments"

}

variable "vpn_gw_generation" {
  type        = string
  default     = "Generation2"
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

variable "bgp_asn_number" {
  type        = string
  default     = "65515"
  description = "The Autonomous System Number (ASN) to use as part of the BGP"

}

variable "bgp_peering_address" {
  type        = string
  default     = ""
  description = "The BGP peer IP address of the virtual network gateway. This address is needed to configure the created gateway as a BGP Peer on the on-premises VPN devices. The IP address must be part of the subnet of the Virtual Network Gateway."

}

variable "bgp_peer_weight" {
  type        = string
  default     = ""
  description = "The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100"
}

variable "vpn_client_configuration" {
  type        = object({ address_space = string, vpn_client_protocols = list(string), aad_tenant = string, aad_audience = string, aad_issuer = string, vpn_auth_types = list(string) })
  default     = null
  description = "Virtual Network Gateway client configuration to accept IPSec point-to-site connections"
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
  description = "The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet)"
  default     = "IPsec"
}

variable "express_route_circuit_id" {
  description = "The ID of the Express Route Circuit when creating an ExpressRoute connection"
  default     = null
}

variable "peer_virtual_network_gateway_id" {
  description = "The ID of the peer virtual network gateway when creating a VNet-to-VNet connection"
  default     = null
}

variable "gateway_connection_protocol" {
  description = "The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2"
  default     = "IKEv2"
  type        = string
}

variable "local_networks_ipsec_policy" {
  description = "IPSec policy for local networks. Only a single policy can be defined for a connection."
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "sku" {
  type        = string
  default     = "VpnGw3"
  description = "Configuration of the size and capacity of the virtual network gateway"
}

#Module      : LABEL
#Description : Terraform label module variables.
variable "app_name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
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
variable "retention_policy_enabled" {
  type        = bool
  default     = false
  description = "Is this Retention Policy enabled?"
}
variable "days" {
  type        = number
  default     = "90"
  description = " The number of days for which this Retention Policy should apply."
}
variable "Metric_enable" {
  type        = bool
  default     = true
  description = "Is this Diagnostic Metric enabled? Defaults to true."
}
variable "diagnostic_setting_enable" {
  type    = bool
  default = false
}
variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "category" {
  type        = string
  default     = null
  description = " The name of a Diagnostic Log Category Group for this Resource."
}
variable "log_enabled" {
  type        = string
  default     = true
  description = " Is this Diagnostic Log enabled? Defaults to true."
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
