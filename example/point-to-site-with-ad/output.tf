output "vpn_gw_id" {
  value       = join("", module.vpn.*.vpn_gw_id)
  description = "The ID of the Virtual Network Gateway."
}

