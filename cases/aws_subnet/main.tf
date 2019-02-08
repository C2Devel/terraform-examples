resource "aws_subnet" "test_subnet" {
  # NOTE: 'map_public_ip_on_creation', 'assign_ipv6_address_on_creation',
  #        and 'ipv6_cidr_block' attributes is note supported.
  availability_zone = "${var.az}"

  cidr_block = "${cidrsubnet(aws_vpc.test_vpc.cidr_block, 1, 0)}"
  vpc_id     = "${aws_vpc.test_vpc.id}"
}
