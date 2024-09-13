output "vpn_gw_id" {
  value       = module.vpn[0].vpn_gw_id_certificate
  description = "The ID of the Virtual Network Gateway."
}

