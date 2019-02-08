resource "aws_route_table" "route_table" {
  # NOTE: `propagating_vgws` attribute is not supported.
  vpc_id = "${aws_vpc.test_vpc.id}"

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = "${aws_vpc.test_vpc.id}"
  }
}
