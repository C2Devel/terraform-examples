resource "aws_network_acl" "test_network_acl" {
  vpc_id     = aws_vpc.test_vpc.id
  subnet_ids = [aws_subnet.test_subnet.id]
}

resource "aws_network_acl_rule" "test_rule" {
  # NOTE: 'ipv6_cidr_block' attribute is not supported
  network_acl_id = aws_network_acl.test_network_acl.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 22
  to_port        = 22
  cidr_block     = aws_subnet.test_subnet.cidr_block
}

resource "aws_network_acl_rule" "test_rule_icmp" {
  # NOTE: 'ipv6_cidr_block' attribute is not supported
  network_acl_id = aws_network_acl.test_network_acl.id
  rule_number    = 150
  egress         = true
  protocol       = "icmp"
  rule_action    = "deny"
  icmp_type      = "2"
  icmp_code      = "123"
  from_port      = 0
  to_port        = 0
  cidr_block     = aws_subnet.test_subnet.cidr_block
}
