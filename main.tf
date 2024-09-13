##-----------------------------------------------------------------------------
## Resource Group, VNet, Subnet selection & Random Resources
##-----------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

##-----------------------------------------------------------------------------
## data block called for resource group. 
##-----------------------------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

##-----------------------------------------------------------------------------
## Random string called
## Will be used further in public ip resource in domain name label. 
##-----------------------------------------------------------------------------
resource "random_string" "str" {
  count   = var.enable ? 1 : 0
  length  = 6
  special = false
  upper   = false
  keepers = {
    domain_name_label = var.name
  }
}

##-----------------------------------------------------------------------------
## Public IP for Virtual Network Gateway
##-----------------------------------------------------------------------------
resource "azurerm_public_ip" "pip_gw" {
  count                = var.enable ? 1 : 0
  name                 = format("%s-gw-pip", module.labels.id)
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  allocation_method    = var.public_ip_allocation_method
  sku                  = var.public_ip_sku
  ddos_protection_mode = "VirtualNetworkInherited"
  domain_name_label    = format("gw%s%s", lower(replace(var.name, "/[[:^alnum:]]/", "")), random_string.str[0].result)
  tags                 = module.labels.tags
}


##-----------------------------------------------------------------------------
## Virtual Network Gateway
##-----------------------------------------------------------------------------
resource "azurerm_virtual_network_gateway" "vpngw" {
  count               = var.enable && (var.vpn_ad || var.sts_vpn) ? 1 : 0
  name                = format("%s-vpn-gateway", module.labels.id, )
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  type                = var.gateway_type
  vpn_type            = var.vpn_type
  sku                 = var.sku
  active_active       = var.vpn_gw_sku != "Basic" ? var.enable_active_active : false
  enable_bgp          = var.vpn_gw_sku != "Basic" ? var.enable_bgp : false
  generation          = var.vpn_gw_generation



  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_gw[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  dynamic "ip_configuration" {
    for_each = var.enable_active_active ? [true] : []
    content {
      name                          = "vnetGatewayAAConfig"
      public_ip_address_id          = azurerm_public_ip.pip_gw.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = var.subnet_id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration != null ? [var.vpn_client_configuration] : []
    iterator = vpn
    content {
      address_space        = [vpn.value.address_space]
      aad_tenant           = vpn.value.aad_tenant
      aad_audience         = vpn.value.aad_audience
      aad_issuer           = vpn.value.aad_issuer
      vpn_auth_types       = vpn.value.vpn_auth_types
      vpn_client_protocols = vpn.value.vpn_client_protocols
    }
  }
  tags = module.labels.tags
}


##-----------------------------------------------------------------------------
## Virtual Network Gateway
## Following resource will deploy virtual network gateway with certificate. 
##-----------------------------------------------------------------------------
resource "azurerm_virtual_network_gateway" "vpngw2" {
  count               = var.enable && var.vpn_with_certificate ? 1 : 0
  name                = format("%s-vpn-gateway", module.labels.id, )
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  type                = var.gateway_type
  vpn_type            = var.vpn_type
  sku                 = var.sku
  active_active       = var.vpn_gw_sku != "Basic" ? var.enable_active_active : false
  enable_bgp          = var.vpn_gw_sku != "Basic" ? var.enable_bgp : false
  generation          = var.vpn_gw_generation



  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_gw[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  dynamic "ip_configuration" {
    for_each = var.enable_active_active ? [true] : []
    content {
      name                          = "vnetGatewayAAConfig"
      public_ip_address_id          = azurerm_public_ip.pip_gw.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = var.subnet_id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration_c != null ? [var.vpn_client_configuration_c] : []
    iterator = vpnc
    content {
      address_space = [vpnc.value.address_space]
      root_certificate {
        name             = "point-to-site-root-certifciate"
        public_cert_data = vpnc.value.certificate
      }
      vpn_client_protocols = vpnc.value.vpn_client_protocols
    }
  }
  tags = module.labels.tags
}
##-----------------------------------------------------------------------------
## Local Network Gateway
##-----------------------------------------------------------------------------
resource "azurerm_local_network_gateway" "localgw" {
  count               = var.enable && var.local_networks != null ? length(var.local_networks) : 0
  name                = "localgw-${var.local_networks[count.index].local_gw_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  gateway_address     = var.local_networks[count.index].local_gateway_address
  address_space       = var.local_networks[count.index].local_address_space

  dynamic "bgp_settings" {
    for_each = var.local_bgp_settings != null ? [true] : []
    content {
      asn                 = var.local_bgp_settings[count.index].asn_number
      bgp_peering_address = var.local_bgp_settings[count.index].peering_address
      peer_weight         = var.local_bgp_settings[count.index].peer_weight
    }
  }
  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Virtual Network Gateway Connection
##-----------------------------------------------------------------------------
resource "azurerm_virtual_network_gateway_connection" "az-hub-onprem" {
  count                           = var.enable && var.gateway_connection_type == "ExpressRoute" ? 1 : length(var.local_networks)
  name                            = var.gateway_connection_type == "ExpressRoute" ? "localgw-expressroute-connection" : "localgw-connection-${var.local_networks[count.index].local_gw_name}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  type                            = var.gateway_connection_type
  virtual_network_gateway_id      = var.sts_vpn == true ? azurerm_virtual_network_gateway.vpngw[0].id : azurerm_virtual_network_gateway.vpngw2[0].id
  local_network_gateway_id        = var.gateway_connection_type != "ExpressRoute" ? azurerm_local_network_gateway.localgw[count.index].id : null
  express_route_circuit_id        = var.gateway_connection_type == "ExpressRoute" ? var.express_route_circuit_id : null
  peer_virtual_network_gateway_id = var.gateway_connection_type == "Vnet2Vnet" ? var.peer_virtual_network_gateway_id : null
  shared_key                      = var.gateway_connection_type != "ExpressRoute" ? var.local_networks[count.index].shared_key : null
  connection_protocol             = var.gateway_connection_type == "IPSec" && var.vpn_gw_sku == ["VpnGw1", "VpnGw2", "VpnGw3", "VpnGw1AZ", "VpnGw2AZ", "VpnGw3AZ"] ? var.gateway_connection_protocol : null

  dynamic "ipsec_policy" {
    for_each = var.local_networks_ipsec_policy != null ? [true] : []
    content {
      dh_group         = var.local_networks_ipsec_policy.dh_group
      ike_encryption   = var.local_networks_ipsec_policy.ike_encryption
      ike_integrity    = var.local_networks_ipsec_policy.ike_integrity
      ipsec_encryption = var.local_networks_ipsec_policy.ipsec_encryption
      ipsec_integrity  = var.local_networks_ipsec_policy.ipsec_integrity
      pfs_group        = var.local_networks_ipsec_policy.pfs_group
      sa_datasize      = var.local_networks_ipsec_policy.sa_datasize
      sa_lifetime      = var.local_networks_ipsec_policy.sa_lifetime
    }
  }
  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Following resource will deploy diagnostic setting for virtual network gateway. 
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "main" {
  count                          = var.enable && var.diagnostic_setting_enable ? 1 : 0
  name                           = format("%s-vpn-gateway-diagnostic-log", module.labels.id)
  target_resource_id             = var.vpn_ad || var.sts_vpn ? azurerm_virtual_network_gateway.vpngw[0].id : azurerm_virtual_network_gateway.vpngw2[0].id
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  metric {
    category = "AllMetrics"
    enabled  = var.Metric_enable
    retention_policy {
      enabled = var.retention_policy_enabled
      days    = var.days
    }
  }
  enabled_log {
    category       = var.category
    category_group = "AllLogs"
    retention_policy {
      enabled = var.retention_policy_enabled
      days    = var.days
    }
  }

  enabled_log {
    category       = var.category
    category_group = "Audit"
    retention_policy {
      enabled = var.retention_policy_enabled
      days    = var.days
    }
  }
  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}

##-----------------------------------------------------------------------------
## Following resource will deploy diagnostic setting for public ip. 
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "pip_gw" {
  count                          = var.enable && var.diagnostic_setting_enable ? 1 : 0
  name                           = format("%s-gw-pip-diagnostic-log", module.labels.id)
  target_resource_id             = azurerm_public_ip.pip_gw[0].id
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  metric {
    category = "AllMetrics"
    enabled  = var.Metric_enable
    retention_policy {
      enabled = var.retention_policy_enabled
      days    = var.days
    }
  }
  enabled_log {
    category       = var.category
    category_group = "AllLogs"
    retention_policy {
      enabled = var.retention_policy_enabled
      days    = var.days
    }
  }

  enabled_log {
    category       = var.category
    category_group = "Audit"
    retention_policy {
      enabled = var.retention_policy_enabled
      days    = var.days
    }
  }
  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}
