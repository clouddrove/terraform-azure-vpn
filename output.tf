output "vpn_gw_id" {
  value       = join("", azurerm_virtual_network_gateway.vpngw[*].id)
  description = "The ID of the Virtual Network Gateway."
}

output "vpn_gw_id_certificate" {
  value       = join("", azurerm_virtual_network_gateway.vpngw2[*].id)
  description = "The ID of the Virtual Network Gateway."
}

output "local_network_gw_id" {
  value       = join("", azurerm_local_network_gateway.localgw[*].id)
  description = "The ID of the Local Network Gateway."
}

output "local_network_gw_connection_id" {
  value       = join("", azurerm_virtual_network_gateway_connection.az-hub-onprem[*].id)
  description = "The ID of the Virtual Network Gateway Connection."
}

output "vpn_gateway_public_ip" {
  description = "The public IP of the virtual network gateway"
  value       = flatten(concat([azurerm_public_ip.pip_gw[0].ip_address], [var.enable_active_active != null ? azurerm_public_ip.pip_gw[0].ip_address : null]))
}

output "vpn_gateway_public_ip_fqdn" {
  description = "Fully qualified domain name of the virtual network gateway"
  value       = flatten(concat([azurerm_public_ip.pip_gw[0].fqdn], [var.enable_active_active != null ? azurerm_public_ip.pip_gw[0].fqdn : null]))
}
