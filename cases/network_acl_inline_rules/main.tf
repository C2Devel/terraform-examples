resource "aws_network_acl" "test_network_acl" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol        = "tcp"
    rule_no         = 100
    action          = "allow"
    from_port       = 80
    to_port         = 80
    ipv6_cidr_block = "2001:db8:1234:1a00::/64"
  }

  subnet_ids = ["${aws_subnet.test_subnet.*.id}"]
}
