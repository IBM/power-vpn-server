##############################################################################
# Terraform Main IaC
##############################################################################
# Generate random identifier
resource "random_string" "resource_identifier" {
  length  = 5
  upper   = false
  numeric = false
  lower   = true
  special = false
}

locals {
  uname = format("%s-%s", var.name, random_string.resource_identifier.result)
}

data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

data "ibm_resource_group" "secret_manager" {
  name = var.secret_manager_resource_group_name == "" ? var.resource_group_name : var.secret_manager_resource_group_name
}

data "ibm_resource_group" "cos_instance" {
  name = var.cos_instance_resource_group_name == "" ? var.resource_group_name : var.cos_instance_resource_group_name
}

module "certificate" {
  source              = "./modules/certificate"
  secret_manager_name = var.secret_manager_name
  resource_group_id   = data.ibm_resource_group.secret_manager.id
  name                = local.uname
}

module "vpc" {
  source            = "./modules/vpc"
  name              = var.name
  resource_group_id = data.ibm_resource_group.group.id
}

module "vpn" {
  source            = "./modules/vpn"
  name              = var.name
  resource_group_id = data.ibm_resource_group.group.id
  certificate_crn   = module.certificate.server_cert_crn
  client_cidr       = var.vpn_client_cidr
  subnet_cidr       = var.vpn_subnet_cidr
  zone              = local.location.vpc_zone
  vpc_id            = module.vpc.vpc.id
}

module "ovpn" {
  source       = "./modules/ovpn"
  vpn_hostname = module.vpn.hostname
  ca           = module.certificate.ca
  client_cert  = module.certificate.client_cert
  client_key   = module.certificate.client_key
}

module "cos_upload" {
  source            = "./modules/cos-upload"
  key               = format("%s.ovpn", var.name)
  content           = module.ovpn.data
  instance_name     = var.cos_instance_name
  bucket_name       = local.uname
  bucket_region     = local.location.vpc_region
  resource_group_id = data.ibm_resource_group.cos_instance.id
}

# If a power workspace name is provided, look it up
data "ibm_resource_instance" "power_workspace" {
  count   = var.power_workspace_name == "" ? 0 : 1
  name    = var.power_workspace_name
  service = "power-iaas"
}

# Only create a new power workspace when neither an existing
# power workspace or transit gateway are supplied
module "power" {
  count             = var.power_workspace_name == "" && var.transit_gateway_name == "" ? 1 : 0
  source            = "./modules/power"
  name              = var.name
  resource_group_id = data.ibm_resource_group.group.id
  location          = var.power_workspace_location
}

locals {
  power_workspace = var.transit_gateway_name == "" ? var.power_workspace_name == "" ? module.power[0].workspace : data.ibm_resource_instance.power_workspace[0] : null
}

# For locations that are not PER enabled create a Cloud Connection that is Transit Gateway enabled.
# This allows us to use the Directlink connection it created and attach it to our Transit Gateway.
# If an existing Transit Gateway is supplied, we assume that this connection (or PER) is already
# connected to the Transit Gateway and will not create the cloud connection to enable it.
module "cloud_connection" {
  count                  = var.transit_gateway_name != "" || local.location.per_enabled ? 0 : 1
  source                 = "./modules/cloud-connection"
  name                   = local.uname
  cloud_connection_speed = var.power_cloud_connection_speed
  power_workspace_id     = local.power_workspace.guid
  providers              = { ibm = ibm.power }
}

# Connect the VPC and Power Workspace to the Transit Gateway
# If the Workspace is PER enabled it maybe directly connected to
# the Gateway, otherwise the Directlink Gateway created by
# the Cloud Connection is used. If a Transit Gateway is
# supplied, only create the VPC connection.
locals {
  vpc_connection = {
    network_type = "vpc"
    network_id   = module.vpc.vpc.crn
  }
  power_connection = {
    network_type = "power_virtual_server"
    network_id   = var.transit_gateway_name == "" ? local.power_workspace.id : ""
  }
  directlink_connection = {
    network_type = "directlink"
    network_id   = length(module.cloud_connection) == 0 ? "" : module.cloud_connection[0].dl_gateway.crn
  }
  connections = var.transit_gateway_name != "" ? [local.vpc_connection] : local.location.per_enabled ? [local.vpc_connection, local.power_connection] : [local.vpc_connection, local.directlink_connection]
}

module "transit" {
  source            = "./modules/transit"
  name              = var.transit_gateway_name == "" ? var.name : var.transit_gateway_name
  region            = local.location.vpc_region
  resource_group_id = data.ibm_resource_group.group.id
  connections       = local.connections
}

locals {
  bucket_url = module.cos_upload.bucket_url
}
