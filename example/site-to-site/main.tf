provider "azurerm" {
  features {}
  subscription_id = ""
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.0"

  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

#Vnet
module "vnet" {
  depends_on = [module.resource_group]
  source     = "clouddrove/virtual-network/azure"
  version    = "1.0.4"

  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
  enable_ddos_pp      = false

  #subnet
  specific_name_subnet          = true
  specific_subnet_names         = "GatewaySubnet"
  subnet_prefixes               = ["10.0.1.0/24"]
  disable_bgp_route_propagation = false

  # routes
  enabled_route_table = false
}


module "vpn" {
  depends_on = [module.vnet]
  source     = "./../../"

  name                 = "site-to-site"
  environment          = "test"
  label_order          = ["name", "environment"]
  sts_vpn              = true
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.vnet.vnet_name[0]
  gateway_type         = "Vpn"
  local_networks = [
    {
      local_gw_name         = "app-test-onpremise"
      local_gateway_address = "20.232.135.45"
      local_address_space   = ["30.1.0.0/16"]
      shared_key            = "xpCGkHTBQmDvZK9HnLr7DAvH"
    },
  ]

}
