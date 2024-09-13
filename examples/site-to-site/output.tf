output "vpn_gw_id" {
  value       = module.vpn[0].vpn_gw_id
  description = "The ID of the Virtual Network Gateway."
}
output "local_network_gw_id" {
  value       = module.vpn[0].local_network_gw_id
  description = "The ID of the Local Network Gateway."
}

output "local_network_gw_connection_id" {
  value       = module.vpn[0].local_network_gw_connection_id
  description = "The ID of the Virtual Network Gateway Connection."
}
