locals {
  ids = ["${aws_instance.test_instance.id}", "${aws_customer_gateway.test_gateway.id}"]
}

resource "aws_customer_gateway" "test_gateway" {
  bgp_asn    = 65000
  ip_address = "172.0.0.1"
  type       = "ipsec.1"
}

resource "aws_instance" "test_instance" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.test_subnet.id}"
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}

resource "aws_route" "route" {
  # NOTE: 'destination_ipv6_cidr_block', 'egress_only_gateway_id',
  #       'nat_gateway_id', 'network_interface_id', 'transit_gateway_id',
  #       'vpc_peering_connection_id' attributes are not supported.
  #       For 'gateway_id' attribute you can supply 'instance_id',
  #       'gateway_id'.
  count = 2

  route_table_id = "${aws_route_table.route_table.id}"

  destination_cidr_block = "${cidrhost(cidrsubnet(aws_vpc.test_vpc.cidr_block, 1, 1), count.index)}"
  gateway_id             = "${local.ids[count.index]}"
}
