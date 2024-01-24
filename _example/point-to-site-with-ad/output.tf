output "vpn_gw_id" {
  value       = join("", module.vpn[*].vpn_gw_id)
  description = "The ID of the Virtual Network Gateway."
}

output "vpn_gw_public_ip_fqdn" {
  description = "Fully qualified domain name of the virtual network gateway"
  value       = module.vpn.vpn_gateway_public_ip_fqdn
}
