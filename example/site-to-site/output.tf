output "vpn_gw_id" {
  value       = join("", module.vpn-gateway.*.vpn_gw_id)
  description = "The ID of the Virtual Network Gateway."
}
output "local_network_gw_id" {
  value       = join("", module.vpn-gateway.*.local_network_gw_id)
  description = "The ID of the Local Network Gateway."
}

output "local_network_gw_connection_id" {
  value       = join("", module.vpn-gateway.*.local_network_gw_connection_id)
  description = "The ID of the Virtual Network Gateway Connection."
}
