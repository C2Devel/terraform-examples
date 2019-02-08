resource "aws_security_group" "security_group" {
  # NOTE: 'revoke_rules_on_delete', 'prefix_list_ids' attributes are not supported.
  vpc_id      = "${aws_vpc.test_vpc.id}"
  name_prefix = "sg_"
  description = "security group description"

  ingress {
    self            = true
    from_port       = 0
    to_port         = 65535
    protocol        = "udp"
    security_groups = ["${aws_security_group.test_security_group.id}"]
  }

  ingress {
    ipv6_cidr_blocks = ["fdf9:3e0e:6345:5578::/64"]
    protocol         = "tcp"
    to_port          = 22
    from_port        = 22
  }

  egress {
    cidr_blocks = ["192.168.1.0/24", "1.2.3.4/32"]
    protocol    = "icmp"
    to_port     = 2
    from_port   = 200
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "udp"
    security_groups = ["${aws_security_group.test_security_group.id}"]
  }
}
