output "vpn_gw_id" {
  value       = try( azurerm_virtual_network_gateway.vpngw[0].id, null)
  description = "The ID of the Virtual Network Gateway."
}

output "vpn_gw_id_certificate" {
  value       = try( azurerm_virtual_network_gateway.vpngw2[0].id, null)
  description = "The ID of the Virtual Network Gateway."
}

output "local_network_gw_id" {
  value       = try(azurerm_local_network_gateway.localgw[*].id, null)
  description = "The ID of the Local Network Gateway."
}
output "local_network_gw_connection_id" {
  value       = try( azurerm_virtual_network_gateway_connection.az-hub-onprem[*].id, null)
  description = "The ID of the Virtual Network Gateway Connection."
}
