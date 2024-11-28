provider "azurerm" {
  features {}
  subscription_id = "000000-11111-1223-XXX-XXXXXXXXXXXX"
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
  version              = "1.2.1"
  name                 = local.name
  environment          = local.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet.vnet_name)
  #subnet
  specific_name_subnet  = true
  specific_subnet_names = ["GatewaySubnet"]
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
## Log Analytics module call.
##-----------------------------------------------------------------------------
module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "1.1.0"
  name                             = local.name
  environment                      = local.environment
  create_log_analytics_workspace   = true
  log_analytics_workspace_sku      = "PerGB2018"
  retention_in_days                = 90
  daily_quota_gb                   = "-1"
  internet_ingestion_enabled       = true
  internet_query_enabled           = true
  resource_group_name              = module.resource_group.resource_group_name
  log_analytics_workspace_location = module.resource_group.resource_group_location
  log_analytics_workspace_id       = module.log-analytics.workspace_id
}

##-----------------------------------------------------------------------------
## VPN module call.
## Following module will deploy point to site vpn with ssl certificate in azure infratsructure.
##-----------------------------------------------------------------------------
module "vpn" {
  source               = "../../"
  depends_on           = [module.vnet]
  name                 = local.name
  environment          = local.environment
  vpn_with_certificate = true
  resource_group_name  = module.resource_group.resource_group_name
  subnet_id            = module.subnet.specific_subnet_id[0]
  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = module.log-analytics.workspace_id
  vpn_client_configuration_c = {
    address_space        = "172.16.201.0/24"
    vpn_client_protocols = ["OpenVPN", "IkeV2"]
    certificate          = <<EOF
MIIC5jCCAc6gAwIBAgIIUeUhLYf6UNwwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UE
AxMGVlBOIENBMB4XDTIyMTExMTE0MzA1NFoXDTI1MTExMDE0MzA1NFowETEPMA0G
A1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6bxr
s1kwbRztA7mH79EoIlyZsmAhdIXV8ehbzNIank1ByOqtBpQK1Xvde1z6rjL1hzCn
XD6xjW+xfF+yQ/zMyc6udrK2OvtuFmAsBYL5Bbb+Nf7U6Rp9IWZA6f/HO+XLft6q
sC0UD1wEK6LSn/1u+fCfT3UCMCjpskAtE3ossZCuhUjJ8jGNUb07Z84dQEQf0s3n
13V0kqNfpaxAhlWUVWrvKWlEGigoTqk6NcTNAzUEGR1b4Rt8qNzIwk8DhODfiOwT
ILsB3XWyA/IOv2eL3Eqx/lkykIBSEJALPE7j6igyTMoSPHtQA7NWrgYeWgiWh1AQ
VJpuY1vAIm3gfMAEoQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB
/wQEAwIBBjAdBgNVHQ4EFgQUiEbr34wufRJ6+1Fh5am89bxRCuswDQYJKoZIhvcN
AQELBQADggEBABHs7e6X2uLpUPkfv0r8TH3MnskPEGObcqGDS8WWH0FO7hsbSMeZ
bTxJue6WTUvwrxYrmfqRZU/K+TtDregsa+GAYsl0wbl82nu2gBivpARLXYenfmwc
Zgul+ZwQPw7FB9rLugW7qKMhGUxYYnywTyfZI1EjP6ZAjYn7xB9G7zOGpkVCErPn
LIO1Knhk7J2XIXs6wCw1OcLJfXhjEEbnYZaHYA3LCTot9LM+3ecloILUo7rQgooB
4/YOgmo7Q3Qv0ahFvsEI/ZqSop6NpLlzIQ/T3hC/6m4aG/1u+yaac4E9ygZNg184
Mb0BNzEPxRFt+L8A72gd/nTcxGrxEcQlqEc=
EOF
  }
}
