##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "power_workspace_location" {
  description = <<-EOF
    The location used to create the power workspace.
    Available locations are: dal10, dal12, us-south, us-east, wdc06, wdc07, sao01, sao04, tor01, mon01, eu-de-1, eu-de-2, lon04, lon06, syd04, syd05, tok04, osa21
    Please see [PowerVS Locations](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server) for an updated list.
  EOF
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group to create new resources in (Resource Group name is case sensitive)."
  type        = string
}

variable "secret_manager_name" {
  description = "Secret Manager to create secret in. This maybe located in any Resource Group (use `secret_manager_resource_group_name`) or Region."
  type        = string
}

variable "cos_instance_name" {
  description = "COS instance name to create a bucket with ovpn file in."
  type        = string
}

variable "name" {
  description = "The name used for the new Power Workspace, Transit Gateway, and VPC. Other resources will use this for their basename and be suffixed by a random identifier."
  type        = string
}

variable "secret_manager_resource_group_name" {
  description = "Resource Group the Secret Manager is in."
  type        = string
  default     = ""
}

variable "cos_instance_resource_group_name" {
  description = "Resource Group the COS Instance is in."
  type        = string
  default     = ""
}

variable "transit_gateway_name" {
  description = "Name of an existing transit gateway, if supplied it is assumed that you've connected your power workspace to it. A connection to the VPC containing the VPN Server will be added, but not for the Power Workspace. Supplying this will also supress Power Workspace creation."
  type        = string
  default     = ""
}

variable "power_cloud_connection_speed" {
  description = "Speed of the cloud connection (speed in megabits per second). Supported values are 50, 100, 200, 500, 1000, 2000, 5000, 10000."
  type        = number
  default     = 1000
}

variable "power_workspace_name" {
  description = "Name of an existing power workspace, if supplied the workspace will be used to connect the VPN with. Must be a PER enabled location."
  type        = string
  default     = ""
}

variable "vpn_subnet_cidr" {
  description = "CIDR for VPN subnet, change this if you have conflict in your VPC or with your Power Workstation Subnets."
  type        = string
  default     = "10.134.0.0/28"
}

variable "vpn_client_cidr" {
  description = "CIDR for VPN client ip pool space."
  type        = string
  default     = "192.168.8.0/22"
}

variable "data_location_file_path" {
  description = "Where the file with PER location data is stored. This variable is used for testing, and should not normally be altered."
  type        = string
  default     = "./data/locations.yaml"
}
