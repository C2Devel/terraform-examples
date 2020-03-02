resource "aws_security_group" "source_security_group" {
  vpc_id = aws_vpc.test_vpc.id
  name   = "source_security_group"
}

resource "aws_security_group_rule" "allow_udp" {
  # NOTE: 'prefix_list_ids ' attributes are not supported
  type                     = "ingress"
  from_port                = 11
  to_port                  = 33
  description              = "some_description"
  protocol                 = "udp"
  source_security_group_id = aws_security_group.source_security_group.id
  security_group_id        = aws_security_group.test_security_group.id
}

resource "aws_security_group_rule" "allow_icmp" {
  type              = "egress"
  from_port         = 0
  to_port           = 255
  protocol          = "icmp"
  cidr_blocks       = ["1.1.1.0/24"]
  security_group_id = aws_security_group.test_security_group.id
}
