<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AZURE VPN
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module to create vpn resource on AZURE.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.1.7-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-azure-vpn'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AZURE+VPN&url=https://github.com/clouddrove/terraform-azure-vpn'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AZURE+VPN&url=https://github.com/clouddrove/terraform-azure-vpn'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-azure-vpn/releases).


Here are some examples of how you can use this module in your inventory structure:
### Default vnet-peering
```hcl
  #  vpn with azure ad
  module "vpn" {
  source                      = "clouddrove/vpn/azure"
  version                     = "1.0.0"
  depends_on                  = [module.vnet]
  name                        = "app"
  environment                 = "test"
  label_order                 = ["name", "environment"]
  vpn_ad                      = true
  resource_group_name         = module.resource_group.resource_group_name
  virtual_network_name        = module.vnet.vnet_name[0]
  vpn_client_configuration    = {
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
  ```
```hcl
#  vpn with certificate
  module "vpn" {
  source                      = "clouddrove/vpn/azure"
  version                     = "1.0.0"
  depends_on                  = [module.vnet]
  name                        = "app"
  environment                 = "test"
  label_order                 = ["name", "environment"]
  vpn_with_certificate        = true
  resource_group_name         = module.resource_group.resource_group_name
  virtual_network_name        = module.vnet.vnet_name[0]
  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = ""
  vpn_client_configuration_c  = {
    address_space        = "172.16.201.0/24"
    vpn_client_protocols = ["OpenVPN", "IkeV2"]
    certificate          = <<EOF
  MIIC5jCCAc6gAwIBAgIIUeUhLYf6UNwwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UE
  AxMGVlBOIENBMB4XDTIyMTExMTE0MzA1NFoXDTI1MTExMDE0MzA1NFowETEPMA0G
  A1UEAxMGVlBOIENBMIIBIjaNBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6bxr
  s1kwbRztA7mH79EoIlyZsmAhdIXV8ehbzNIakk1ByOqtBpQK1Xvde1z6rjL1hzCn
  XD6xjW+xfF+yQ/zMyc6udrK2OvtuFmAsBYL5Bbb+Nf7U6Rp9IWZA6f/HO+XLft6q
  sC0UD1wEK6LSn/1u+fCfT3UCMCjpskAtE3ossZCuhUjJ8jGNUb07Z84dQEQf0s3n
  13V0kqNfpaxAhlWUVWrvKWlEGigoTqk4NcTNAzUEGR1b4Rt8qNzIwk8DhODfiOwT
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
  ```
```hcl
#  site-to-site vpn
  module "vpn" {
  source                      = "clouddrove/vpn/azure"
  version                     = "1.0.0"
  name                        = "site-to-site"
  environment                 = "test"
  label_order                 = ["name", "environment"]
  sts_vpn                     = true
  resource_group_name         = module.resource_group.resource_group_name
  virtual_network_name        = module.vnet.vnet_name[0]
  gateway_type                = "Vpn"

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
 ```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| Metric\_enable | Is this Diagnostic Metric enabled? Defaults to true. | `bool` | `true` | no |
| app\_name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| bgp\_asn\_number | The Autonomous System Number (ASN) to use as part of the BGP | `string` | `"65515"` | no |
| bgp\_peer\_weight | The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100 | `string` | `""` | no |
| bgp\_peering\_address | The BGP peer IP address of the virtual network gateway. This address is needed to configure the created gateway as a BGP Peer on the on-premises VPN devices. The IP address must be part of the subnet of the Virtual Network Gateway. | `string` | `""` | no |
| category | The name of a Diagnostic Log Category Group for this Resource. | `string` | `null` | no |
| days | The number of days for which this Retention Policy should apply. | `number` | `"90"` | no |
| diagnostic\_setting\_enable | n/a | `bool` | `false` | no |
| enable | Flag to control module creation. | `bool` | `true` | no |
| enable\_active\_active | If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false. | `bool` | `false` | no |
| enable\_bgp | If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false | `bool` | `false` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| eventhub\_authorization\_rule\_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | `string` | `null` | no |
| eventhub\_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. | `string` | `null` | no |
| express\_route\_circuit\_id | The ID of the Express Route Circuit when creating an ExpressRoute connection | `any` | `null` | no |
| expressroute\_sku | Configuration of the size and capacity of the virtual network gateway for ExpressRoute type. Valid options are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ and depend on the type, vpn\_type and generation arguments | `string` | `"Standard"` | no |
| gateway\_connection\_protocol | The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2 | `string` | `"IKEv2"` | no |
| gateway\_connection\_type | The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet) | `string` | `"IPsec"` | no |
| gateway\_type | The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute | `string` | `"Vpn"` | no |
| label\_order | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| local\_bgp\_settings | Local Network Gateway's BGP speaker settings | `list(object({ asn_number = number, peering_address = string, peer_weight = number }))` | `null` | no |
| local\_networks | List of local virtual network connections to connect to gateway | `list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string }))` | `[]` | no |
| local\_networks\_ipsec\_policy | IPSec policy for local networks. Only a single policy can be defined for a connection. | `any` | `null` | no |
| location | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `""` | no |
| log\_analytics\_destination\_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| log\_analytics\_workspace\_id | n/a | `string` | `null` | no |
| log\_enabled | Is this Diagnostic Log enabled? Defaults to true. | `string` | `true` | no |
| managedby | ManagedBy, eg ''. | `string` | `""` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| peer\_virtual\_network\_gateway\_id | The ID of the peer virtual network gateway when creating a VNet-to-VNet connection | `any` | `null` | no |
| public\_ip\_allocation\_method | Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic | `string` | `"Dynamic"` | no |
| public\_ip\_sku | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic | `string` | `"Basic"` | no |
| repository | Terraform current module repo | `string` | `""` | no |
| resource\_group\_name | A container that holds related resources for an Azure solution | `string` | `""` | no |
| retention\_policy\_enabled | Is this Retention Policy enabled? | `bool` | `false` | no |
| sku | Configuration of the size and capacity of the virtual network gateway | `string` | `"VpnGw3"` | no |
| storage\_account\_id | The ID of the Storage Account where logs should be sent. | `string` | `null` | no |
| sts\_vpn | Set to false to prevent the module from creating any resources. | `bool` | `false` | no |
| subnet\_id | The ID of the Subnet where this Network Interface should be located in. | `string` | `""` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpn\_ad | Set to false to prevent the module from creating any resources. | `bool` | `false` | no |
| vpn\_client\_configuration | Virtual Network Gateway client configuration to accept IPSec point-to-site connections | `object({ address_space = string, vpn_client_protocols = list(string), aad_tenant = string, aad_audience = string, aad_issuer = string, vpn_auth_types = list(string) })` | `null` | no |
| vpn\_client\_configuration\_c | Virtual Network Gateway client configuration to accept IPSec point-to-site connections | `object({ address_space = string, vpn_client_protocols = list(string), certificate = string })` | `null` | no |
| vpn\_gateway\_name | The name of the Virtual Network Gateway | `string` | `""` | no |
| vpn\_gw\_generation | The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None | `string` | `"Generation2"` | no |
| vpn\_gw\_sku | Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw3, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw3AZ, VpnGw3, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn\_type and generation arguments | `string` | `"VpnGw3"` | no |
| vpn\_type | The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased | `string` | `"RouteBased"` | no |
| vpn\_with\_certificate | Set to false to prevent the module from creating any resources. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| local\_network\_gw\_connection\_id | The ID of the Virtual Network Gateway Connection. |
| local\_network\_gw\_id | The ID of the Local Network Gateway. |
| vpn\_gw\_id | The ID of the Virtual Network Gateway. |
| vpn\_gw\_id\_certificate | The ID of the Virtual Network Gateway. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-azure-vpn/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-azure-vpn)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
