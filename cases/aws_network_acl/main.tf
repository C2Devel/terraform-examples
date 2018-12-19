resource "aws_network_acl" "test_network_acl" {
  # NOTE: 'ipv6_cidr_block' and 'subnet_id' attributes are not supported.
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
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    from_port  = 80
    to_port    = 80
    cidr_block = "2.2.2.2/32"
  }

  egress {
    to_port   = 0
    from_port = 0
    protocol  = "icmp"

    rule_no    = 200
    action     = "deny"
    icmp_type  = 1
    icmp_code  = 255
    cidr_block = "1.2.3.4/32"
  }

  subnet_ids = ["${aws_subnet.test_subnet.id}"]
}
