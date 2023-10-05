resource "ibm_is_vpc_address_prefix" "prefix" {
  name = format("%s-%s", var.name, "prefix")
  zone = var.zone
  vpc  = var.vpc_id
  cidr = var.subnet_cidr
}

resource "ibm_is_subnet" "subnet" {
  depends_on = [
    ibm_is_vpc_address_prefix.prefix
  ]

  ipv4_cidr_block = var.subnet_cidr
  name            = format("%s-%s", var.name, "subnet")
  vpc             = var.vpc_id
  zone            = var.zone
  resource_group  = var.resource_group_id
}

resource "ibm_is_security_group" "sg" {
  name           = format("%s-%s", var.name, "sec-group")
  vpc            = var.vpc_id
  resource_group = var.resource_group_id
}

resource "ibm_is_security_group_rule" "ingress" {
  group     = ibm_is_security_group.sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "egress" {
  group     = ibm_is_security_group.sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_vpn_server" "vpc" {
  certificate_crn        = var.certificate_crn
  client_ip_pool         = var.client_cidr
  enable_split_tunneling = true
  name                   = var.name
  subnets                = [ibm_is_subnet.subnet.id]
  security_groups        = [ibm_is_security_group.sg.id]
  resource_group         = var.resource_group_id

  client_authentication {
    method        = "certificate"
    client_ca_crn = var.certificate_crn
  }
}

resource "ibm_is_vpn_server_route" "route" {
  name        = format("%s-%s", var.name, "route")
  vpn_server  = ibm_is_vpn_server.vpc.id
  destination = "10.0.0.0/8"
  action      = "deliver"
}

# Allows VPN Server <=> Transit Gateway traffic
resource "ibm_is_vpc_routing_table" "transit" {
  vpc                              = ibm_is_subnet.subnet.vpc
  name                             = format("%s-%s", var.name, "route-table-vpn-server-transit")
  route_transit_gateway_ingress    = true
  accept_routes_from_resource_type = ["vpn_server"]
}

# Allows VPN Clients <=> Transit Gateway traffic
resource "ibm_is_vpc_address_prefix" "client_prefix" {
  depends_on = [
    ibm_is_vpn_server.vpc
  ]
  name = format("%s-%s", var.name, "prefix-vpn-client")
  zone = var.zone
  vpc  = var.vpc_id
  cidr = var.client_cidr
}
