# PowerVPN Client to Site Server

## Overview

This Terraform module will create a VPC VPN Server and attach it to a new or existing PowerVS
Workspace. Providing secure access to IBM Cloud Power infrastructure.

This Terraform module deploys the following infrastructure:

- VPC
- VPC Subnet
- VPC Security Groups
- VPC VPN Server
- COS Bucket with OVPN file
- Secrets Manager Certificate
- PowerVS Workspace (Optional)
- Transit Gateway (Optional)
- Cloud Connection w/DirectLink* (Optional)

\* Only in locations without
[Power Edge Routers](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-per)

### Deployment Model

![Deployment Model](./doc/materials/client-site.png)

### Power Edge Router vs Cloud Connection

This automation includes a [data file](./data/locations.yaml) to determine if a PowerVS location has
a Power Edge Router. If the location does not have a Power Edge Router, the automation will create a
Cloud Connection and connect it's Direct Link connection to the Transit Gateway to route traffic to
the VPC.

When using a PowerVS location where a Cloud Connection is needed, Subnets created in the PowerVS
Workspace will need to be connected with the Cloud Connection before traffic will be routed to the
Transit Gateway. This can be done during the Subnet creation.

![Attach Cloud Connection](./doc/materials/attach-subnet.png)

## Setup Requirements

### Prerequisites

#### Upgrading your IBM Cloud Account

To order and use IBM Cloud services, billing information is required for your account. See
[Upgrading Your Account](https://cloud.ibm.com/docs/account?topic=account-upgrading-account).

#### IAM Access

You will need the following IAM access, or higher, to deploy this VPN

|Service Name</br>(Resource Type)|Service Access|Platform Access|
|---|---|---|
|VPC Infrastructure Services</br>  - Virtual Private Cloud</br>  - Subnet</br>  - Security Group for VPC</br>  - Client VPN for VPC</br>||Editor|
|Cloud Object Storage|Writer||
|Secrets Manager|Writer||
|Transit Gateway</br>  - Transit Gateway|Manager|Editor|
|Workspace for Power Systems Virtual Server|Manager|Editor|

#### Install Terraform

If you wish to run Terraform locally, see
[Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform).

#### IBM Cloud API Key

You must supply an IBM Cloud API key so that Terraform can connect to the IBM Cloud Terraform
provider. See
[Create API Key](https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui#create_user_key).

#### Secrets Manager

You must have in your account an [IBM Secrets Manager](https://www.ibm.com/cloud/secrets-manager).
This will be used to store the certificate created by this module for use with the VPN Server. The
Secret Manager may be located in any region or any Resource Group. To specify a different Resource
Group than the one used to create resources by this module, set the optional variable
`secret_manager_resource_group_name`.

You can create the Secrets Manager by visiting
[IBM Cloud Catalog - Create Secrets Manager](https://cloud.ibm.com/catalog/services/secrets-manager).

#### Authorization Policy

A privileged user for the account will need to
[create an authorization policy](https://cloud.ibm.com/iam/authorizations/grant) that will allow the
VPC VPN Service access to read secrets in the Secret Manager service(s). The policy should look
similar to this:

![Authorization Policy](./doc/materials/authorization_policy.png)

To create the authorization policy you must specify the Source service as
`VPC Infrastructure Services` and then choose to scope resources based on attribute by resource type
`Client VPN for VPC`. The Target service must be set to `Secrets Manager`. You may choose to limit
the scope (but it is not necessary) by various different attributes, including the exact instance
created in the [Secrets Manager Prerequisite](#secrets-manager) step above. Then allow Service
access of `SecretsReader`.

| Source Service | Target Service |
:---:|:---:
| ![Source](./doc/materials/source_vpc_auth_policy.png) | ![Target](./doc/materials/target_sm_auth_policy.png) |

#### Object Storage

You must have in your account an [IBM Cloud Object Storage](https://www.ibm.com/cloud/object-storage)
instance. This will be used to store the OpenVPN configuration file created by this module. The COS
Instance may be located in any Resource Group. To specify a different Resource Group than the one
used to create resources by this module, set the optional variable
`cos_instance_resource_group_name`.

You can create the Object Storage instance by visiting
[IBM Cloud Catalog - Create Object Storage](https://cloud.ibm.com/objectstorage/create).

## Variable Behavior

There are a number of variables defined in variables.tf used by this Terraform module to deploy and
configure your infrastructure. This section will describe variable behavior. See
[variables.tf](./variables.tf) for full list of variables with their descriptions, defaults, and
conditions.

## Support

If you have problems or questions when using the underlying IBM Cloud infrastructure, you can get
help by searching for information or by asking questions through one of the forums. You can also
create a case in the
[IBM Cloud console](https://cloud.ibm.com/unifiedsupport/supportcenter).

For information about opening an IBM support ticket, see
[Contacting support](https://cloud.ibm.com/docs/get-support?topic=get-support-using-avatar).

To report bugs or make feature requests regarding this Terraform module, please create an issue in
this repository.

## References

- [What is Terraform](https://www.terraform.io/intro)
- [IBM Cloud provider Terraform getting started](https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-getting-started)
- [IBM Cloud VPC VPN Server](https://cloud.ibm.com/docs/vpc?topic=vpc-vpn-client-to-site-overview)
- [IBM Cloud PowerVS](https://www.ibm.com/products/power-virtual-server)
- [IBM Power Edge Router](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-per)
- [IBM Cloud Connection](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.62.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.62.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_certificate"></a> [certificate](#module\_certificate) | ./modules/certificate | n/a |
| <a name="module_cloud_connection"></a> [cloud\_connection](#module\_cloud\_connection) | ./modules/cloud-connection | n/a |
| <a name="module_cos_upload"></a> [cos\_upload](#module\_cos\_upload) | ./modules/cos-upload | n/a |
| <a name="module_ovpn"></a> [ovpn](#module\_ovpn) | ./modules/ovpn | n/a |
| <a name="module_power"></a> [power](#module\_power) | ./modules/power | n/a |
| <a name="module_transit"></a> [transit](#module\_transit) | ./modules/transit | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.resource_identifier](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/string) | resource |
| [ibm_resource_group.cos_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.62.0/docs/data-sources/resource_group) | data source |
| [ibm_resource_group.group](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.62.0/docs/data-sources/resource_group) | data source |
| [ibm_resource_group.secret_manager](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.62.0/docs/data-sources/resource_group) | data source |
| [ibm_resource_instance.power_workspace](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.62.0/docs/data-sources/resource_instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cos_instance_name"></a> [cos\_instance\_name](#input\_cos\_instance\_name) | The Cloud Object Storage instance name used to create a bucket with OVPN configuration file in.<br>The configuration file is used with OpenVPN Connect to connect your remote machine with the VPN created in IBM Cloud.<br><br>The COS instance maybe in any Resource Group.<br>By default, the Resource Group specified by the variable `resource_group_name` will be used to locate the COS instance.<br>However, if the COS instance is in another Resource Group use the optional variable `cos_instance_resource_group_name` to specify it. | `string` | n/a | yes |
| <a name="input_cos_instance_resource_group_name"></a> [cos\_instance\_resource\_group\_name](#input\_cos\_instance\_resource\_group\_name) | Optional variable to specify the Resource Group the Cloud Object Storage instance is in.<br>If not supplied, the value specified for `resource_group_name` will be used to locate your COS instance. | `string` | `""` | no |
| <a name="input_create_default_vpc_address_prefixes"></a> [create\_default\_vpc\_address\_prefixes](#input\_create\_default\_vpc\_address\_prefixes) | Optional variable to indicate whether a default address prefix should be created for each zone in this VPC. | `bool` | `false` | no |
| <a name="input_data_location_file_path"></a> [data\_location\_file\_path](#input\_data\_location\_file\_path) | Optional variable to specify Where the file with PER location data is stored. This variable is used<br>for testing, and should not normally need to be altered. | `string` | `"./data/locations.yaml"` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name used for the new Power Workspace, Transit Gateway, and VPC.<br>Other resources created will use this for their basename and be suffixed by a random identifier. | `string` | n/a | yes |
| <a name="input_per_override"></a> [per\_override](#input\_per\_override) | Optional variable to force the PowerVS location to be seen as PER enabled by this automation.<br>When set `true`, this will force the use of PER instead of creating Cloud Connections.<br>Set `true` when a location has been upgraded to PER before this automation has been made aware.<br>See [Getting started with the Power Edge Router](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-per) for a complete list of PER enabled locations. | `bool` | `false` | no |
| <a name="input_power_cloud_connection_speed"></a> [power\_cloud\_connection\_speed](#input\_power\_cloud\_connection\_speed) | Optional variable to specify the speed of the cloud connection (speed in megabits per second).<br>This only applies to locations WITHOUT Power Edge Routers.<br><br>Supported values are 50, 100, 200, 500, 1000, 2000, 5000, 10000. Default Value is 1000. | `number` | `1000` | no |
| <a name="input_power_workspace_location"></a> [power\_workspace\_location](#input\_power\_workspace\_location) | The location used to create the power workspace.<br><br>Available locations are: dal10, dal12, us-south, us-east, wdc06, wdc07, sao01, sao04, tor01, mon01, eu-de-1, eu-de-2, lon04, lon06, syd04, syd05, tok04, osa21, mad02, mad04.<br>Please see [PowerVS Locations](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server) for a complete list of PowerVS locations. | `string` | n/a | yes |
| <a name="input_power_workspace_name"></a> [power\_workspace\_name](#input\_power\_workspace\_name) | Optional variable to specify the name of an existing power workspace.<br>If supplied the workspace will be used to connect the VPN with. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group to create new resources in (Resource Group name is case sensitive).<br><br>This will also be used to locate your existing Secrets Manager and Cloud Object Storage instance.<br>If the Secrets Manager or Cloud Object Storage instance is in a different resource group, use the optional<br>variables `secret_manager_resource_group_name` and `cos_instance_resource_group_name`, respectively, to specify those. | `string` | n/a | yes |
| <a name="input_secret_manager_name"></a> [secret\_manager\_name](#input\_secret\_manager\_name) | The Secrets Manager to create the VPN certificate in.<br><br>The Secrets Manager maybe in any Resource Group or Region.<br>By default, the Resource Group specified by the variable `resource_group_name` will be used to locate the Secrets Manager.<br>However, if the Secrets Manager is in another Resource Group use the optional variable `secret_manager_resource_group_name` to specify it. | `string` | n/a | yes |
| <a name="input_secret_manager_resource_group_name"></a> [secret\_manager\_resource\_group\_name](#input\_secret\_manager\_resource\_group\_name) | Optional variable to specify the Resource Group the Secret Manager is in.<br>If not supplied, the value specified for `resource_group_name` will be used to locate your Secrets Manager. | `string` | `""` | no |
| <a name="input_transit_gateway_name"></a> [transit\_gateway\_name](#input\_transit\_gateway\_name) | Optional variable to specify the name of an existing transit gateway, if supplied it will be assumed that you've connected<br>your power workspace to it. A connection to the VPC containing the VPN Server will be added, but not for the Power Workspace.<br>Supplying this variable will also suppress Power Workspace creation. | `string` | `""` | no |
| <a name="input_vpn_client_cidr"></a> [vpn\_client\_cidr](#input\_vpn\_client\_cidr) | Optional variable to specify the CIDR for VPN client IP pool space. This is the IP space that will be<br>used by machines connecting with the VPN. You should only need to change this if you have a conflict<br>with your local network. | `string` | `"192.168.8.0/22"` | no |
| <a name="input_vpn_subnet_cidr"></a> [vpn\_subnet\_cidr](#input\_vpn\_subnet\_cidr) | Optional variable to specify the CIDR for subnet the VPN will be in. You should only need to change this<br>if you have a conflict with your Power Workstation Subnets or with a VPC connected with this solution. | `string` | `"10.134.0.0/28"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | URL to bucket containing the OVPN file |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
