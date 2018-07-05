# NOTE: In AWS we can specify all 'cidr_block',
#       'ipv6_cidr_block' and 'security_groups'
#       within one inline rule. In C2 only one of
#       these is allowed.

resource "aws_security_group" "_test_security_group" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  ingress {
    self      = true
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "udp"
    security_groups = ["${aws_security_group.test_security_group.*.id}"]
  }
}
