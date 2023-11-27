##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "power_workspace_location" {
  description = <<-EOD
    The location used to create the power workspace.

    Available locations are: dal10, dal12, us-south, us-east, wdc06, wdc07, sao01, sao04, tor01, mon01, eu-de-1, eu-de-2, lon04, lon06, syd04, syd05, tok04, osa21
    Please see [PowerVS Locations](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server) for an updated list.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<-EOD
    Resource Group to create new resources in (Resource Group name is case sensitive).

    This will also be used to locate your existing Secrets Manager and Cloud Object Storage instance.
    If the Secrets Manager or Cloud Object Storage instance is in a different resource group, use the optional
    variables `secret_manager_resource_group_name` and `cos_instance_resource_group_name`, respectively, to specify those.
  EOD
  type        = string
}

variable "secret_manager_name" {
  description = <<-EOD
    The Secrets Manager to create the VPN certificate in.

    The Secrets Manager maybe in any Resource Group or Region.
    By default, the Resource Group specified by the variable `resource_group_name` will be used to locate the Secrets Manager.
    However, if the Secrets Manager is in another Resource Group use the optional variable `secret_manager_resource_group_name` to specify it.
  EOD
  type        = string
}

variable "cos_instance_name" {
  description = <<-EOD
    The Cloud Object Storage instance name used to create a bucket with OVPN configuration file in.
    The configuration file is used with OpenVPN Connect to connect your remote machine with the VPN created in IBM Cloud.

    The COS instance maybe in any Resource Group.
    By default, the Resource Group specified by the variable `resource_group_name` will be used to locate the COS instance.
    However, if the COS instance is in another Resource Group use the optional variable `cos_instance_resource_group_name` to specify it.
  EOD
  type        = string
}

variable "name" {
  description = <<-EOD
    The name used for the new Power Workspace, Transit Gateway, and VPC.
    Other resources created will use this for their basename and be suffixed by a random identifier.
  EOD
  type        = string
}

variable "secret_manager_resource_group_name" {
  description = <<-EOD
    Optional variable to specify the Resource Group the Secret Manager is in.
    If not supplied, the value specified for `resource_group_name` will be used to locate your Secrets Manager.
  EOD
  type        = string
  default     = ""
}

variable "cos_instance_resource_group_name" {
  description = <<-EOD
    Optional variable to specify the Resource Group the Cloud Object Storage instance is in.
    If not supplied, the value specified for `resource_group_name` will be used to locate your COS instance.
  EOD
  type        = string
  default     = ""
}

variable "transit_gateway_name" {
  description = <<-EOD
    Optional variable to specify the name of an existing transit gateway, if supplied it will be assumed that you've connected
    your power workspace to it. A connection to the VPC containing the VPN Server will be added, but not for the Power Workspace.
    Supplying this variable will also suppress Power Workspace creation.
  EOD
  type        = string
  default     = ""
}

variable "power_cloud_connection_speed" {
  description = <<-EOD
    Optional variable to specify the speed of the cloud connection (speed in megabits per second).
    This only applies to locations WITHOUT Power Edge Routers.

    Supported values are 50, 100, 200, 500, 1000, 2000, 5000, 10000. Default Value is 1000.
  EOD
  type        = number
  default     = 1000
}

variable "power_workspace_name" {
  description = <<-EOD
    Optional variable to specify the name of an existing power workspace.
    If supplied the workspace will be used to connect the VPN with.
  EOD
  type        = string
  default     = ""
}

variable "vpn_subnet_cidr" {
  description = <<-EOD
    Optional variable to specify the CIDR for subnet the VPN will be in. You should only need to change this
    if you have a conflict with your Power Workstation Subnets or with a VPC connected with this solution.
  EOD
  type        = string
  default     = "10.134.0.0/28"
}

variable "vpn_client_cidr" {
  description = <<-EOD
    Optional variable to specify the CIDR for VPN client IP pool space. This is the IP space that will be
    used by machines connecting with the VPN. You should only need to change this if you have a conflict
    with your local network.
  EOD
  type        = string
  default     = "192.168.8.0/22"
}

variable "data_location_file_path" {
  description = <<-EOD
    Optional variable to specify Where the file with PER location data is stored. This variable is used
    for testing, and should not normally need to be altered.
  EOD
  type        = string
  default     = "./data/locations.yaml"
}

variable "create_default_vpc_address_prefixes" {
  description = <<-EOD
    Optional variable to indicate whether a default address prefix should be created for each zone in this VPC.
  EOD
  type        = bool
  default     = true
}
