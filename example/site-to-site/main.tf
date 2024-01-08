provider "azurerm" {
  features {}
  subscription_id = ""
}

locals {
  name        = "app"
  environment = "test"
}

##----------------------------------------------------------------------------- 
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.2"
  name        = local.name
  environment = local.environment
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

##----------------------------------------------------------------------------- 
## Virtual Network module call.
## Virtual Network in which vpn subnet(Gateway Subnet) will be created. 
##-----------------------------------------------------------------------------
module "vnet" {
  source              = "clouddrove/vnet/azure"
  version             = "1.0.4"
  name                = local.name
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
}

##----------------------------------------------------------------------------- 
## Subnet module call. 
## Name specific subnet for vpn will be created. 
##-----------------------------------------------------------------------------
module "subnet" {
  source               = "clouddrove/subnet/azure"
  version              = "1.0.2"
  name                 = local.name
  environment          = local.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet.vnet_name)
  #subnet
  specific_name_subnet  = true
  specific_subnet_names = "GatewaySubnet"
  subnet_prefixes       = ["10.0.1.0/24"]
  # route_table
  enable_route_table = false
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

##----------------------------------------------------------------------------- 
## VPN module call. 
## Following module will deploy site to site vpn with ssl certificate in azure infratsructure.  
##-----------------------------------------------------------------------------
module "vpn" {
  depends_on          = [module.vnet]
  source              = "../../"
  name                = "site-to-site"
  environment         = local.environment
  sts_vpn             = true
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.subnet.specific_subnet_id[0]
  gateway_type        = "Vpn"
  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = ""
  local_networks = [
    {
      local_gw_name         = "app-test-onpremise"
      local_gateway_address = "20.232.135.45"
      local_address_space   = ["30.1.0.0/16"]
      shared_key            = "xpCGkHTBQmDvZK9HnLr7DAvH"
    },
  ]
}
