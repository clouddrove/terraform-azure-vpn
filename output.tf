output "vpn_gw_id" {
  value       = length(azurerm_virtual_network_gateway.vpngw) > 0 ? azurerm_virtual_network_gateway.vpngw[0].id : null
  description = "The ID of the Virtual Network Gateway."
}

output "vpn_gw_id_certificate" {
  value       = length(azurerm_virtual_network_gateway.vpngw2) > 0 ? azurerm_virtual_network_gateway.vpngw2[0].id : null
  description = "The ID of the Virtual Network Gateway."
}

output "local_network_gw_id" {
  value       = length(azurerm_local_network_gateway.localgw) > 0 ? azurerm_local_network_gateway.localgw[0].id : null
  description = "The ID of the Local Network Gateway"
}

output "local_network_gw_connection_id" {
  value       = length(azurerm_virtual_network_gateway_connection.az-hub-onprem) > 0 ? azurerm_virtual_network_gateway_connection.az-hub-onprem[0].id : null
  description = "The ID of the Virtual Network Gateway Connection"
}
