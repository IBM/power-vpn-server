
resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
}

resource "tls_private_key" "client_key" {
  algorithm = "RSA"
}

resource "tls_private_key" "server_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca_cert" {
  is_ca_certificate = true
  private_key_pem   = tls_private_key.ca_key.private_key_pem

  subject {
    common_name  = "My Cert Authority"
    organization = "My, Inc"
  }

  validity_period_hours = 3 * 365 * 24

  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

resource "tls_cert_request" "client_request" {
  private_key_pem = tls_private_key.client_key.private_key_pem

  subject {
    common_name  = "my.vpn.client"
    organization = "My, Inc"
  }

}

resource "tls_cert_request" "server_request" {
  private_key_pem = tls_private_key.server_key.private_key_pem

  subject {
    common_name  = "my.vpn.server"
    organization = "My, Inc"
  }
}

resource "tls_locally_signed_cert" "client_cert" {
  cert_request_pem   = tls_cert_request.client_request.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 3 * 365 * 24
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth"
  ]
}

resource "tls_locally_signed_cert" "server_cert" {
  cert_request_pem   = tls_cert_request.server_request.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 3 * 365 * 24
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
}

data "ibm_resource_instance" "secret_manager" {
  service           = "secrets-manager"
  name              = var.secret_manager_name
  resource_group_id = var.resource_group_id
}

resource "ibm_sm_imported_certificate" "server" {
  instance_id  = data.ibm_resource_instance.secret_manager.guid
  region       = data.ibm_resource_instance.secret_manager.location
  name         = var.name
  description  = "Secret for VPN authentication"
  certificate  = tls_locally_signed_cert.server_cert.cert_pem
  private_key  = tls_private_key.server_key.private_key_pem
  intermediate = tls_self_signed_cert.ca_cert.cert_pem
}
