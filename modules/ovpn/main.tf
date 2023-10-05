locals {
  ovpn_data = templatefile("${path.module}/templates/client_config.ovpn.tpl", {
    "hostname"    = var.vpn_hostname,
    "ca"          = var.ca,
    "client_key"  = var.client_key,
    "client_cert" = var.client_cert
  })
}
