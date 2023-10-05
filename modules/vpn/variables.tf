variable "certificate_crn" {
  description = "Server certificate CRN imported in secrets manager"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID of VPC where VPN will be created"
  type        = string
}

variable "zone" {
  description = "Zone where VPN will be located"
  type        = string
}

variable "client_cidr" {
  description = "CIDR for VPN client ip pool space"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR for VPN server ip space"
  type        = string
}

variable "name" {
  description = "basename used for resources created"
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID to create VPN in"
  type        = string
}
