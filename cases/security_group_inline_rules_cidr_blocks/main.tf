# NOTE: In AWS we can specify all 'cidr_block',
#       'ipv6_cidr_block' and 'security_groups'
#       within one inline rule. In C2 only one of
#       these is allowed.

resource "aws_security_group" "test_security_group" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${aws_subnet.test_subnet.*.cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 65535
    protocol         = "udp"
    ipv6_cidr_blocks = ["2001:db8:1234:1a00::/64"]
  }
}
