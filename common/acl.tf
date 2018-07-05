variable "network_acls_count" {
  default = 1
}

resource "aws_network_acl" "test_network_acl" {
  count  = "${var.network_acls_count}"
  vpc_id = "${aws_vpc.test_vpc.id}"
}
