variable "ca" {
  description = "CA used to create imported secret"
  type        = string
  sensitive   = true
}

variable "client_key" {
  description = "Client key created from server cert"
  type        = string
  sensitive   = true
}

variable "client_cert" {
  description = "Client certificate created from server cert"
  type        = string
  sensitive   = true
}

variable "vpn_hostname" {
  description = "Publicly accessable hostname of the VPN server"
  type        = string
}
