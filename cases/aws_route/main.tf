resource "aws_instance" "test_instance" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.test_subnet.id}"
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}

resource "aws_network_interface" "test" {
  subnet_id = "${aws_subnet.test_subnet.id}"
}

resource "aws_route" "test2" {
  # NOTE: 'destination_ipv6_cidr_block', 'egress_only_gateway_id',
  #       'nat_gateway_id', 'transit_gateway_id',
  #       'vpc_peering_connection_id' attributes are not supported.
  #       For 'gateway_id' attribute you can supply vpn_id'.
  destination_cidr_block = "10.0.9.9/32"
  route_table_id = "${aws_route_table.route_table.id}"
  network_interface_id = "${aws_network_interface.test.id}"
}

resource "aws_route" "test3" {
  destination_cidr_block = "10.0.9.10/32"
  route_table_id = "${aws_route_table.route_table.id}"
  instance_id = "${aws_instance.test_instance.id}"
}
