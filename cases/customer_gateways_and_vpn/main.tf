data "aws_vpc" "test_vpc" {
  default = true
}

resource "aws_customer_gateway" "test_customer_gateway" {
  bgp_asn    = 65000
  ip_address = "172.0.0.1"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "test_vpn" {
  # NOTE: VPN Gateway entity implemented inside VPC entity,
  #       so use VPC Id as VPN Gateway Id
  vpn_gateway_id = "${data.aws_vpc.test_vpc.id}"

  customer_gateway_id = "${aws_customer_gateway.test_customer_gateway.id}"
  type                = "ipsec.1"
}
