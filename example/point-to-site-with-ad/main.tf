provider "azurerm" {
  features {}
  subscription_id = ""
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.2"

  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

#Vnet
module "vnet" {
  source              = "clouddrove/vnet/azure"
  version             = "1.0.2"
  name                = "app"
  environment         = "test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
}

module "subnet" {
  source  = "clouddrove/subnet/azure"
  version = "1.0.2"

  name                 = "app"
  environment          = "test"
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


module "vpn" {
  depends_on          = [module.vnet]
  source              = "../../"
  name                = "app"
  environment         = "test"
  vpn_ad              = true
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.subnet.specific_subnet_id[0]
  vpn_client_configuration = {
    address_space        = "172.16.200.0/24"
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
    aad_tenant           = "https://login.microsoftonline.com/bcffb719XXXXXXXXXXXX7ebfb2f7bdd"
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer           = "https://sts.windows.net/bcffb719XXXXXXXXXXXX7ebfb2f7bdd/"

  }

  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = ""

}
