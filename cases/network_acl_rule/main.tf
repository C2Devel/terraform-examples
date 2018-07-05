# NOTE: Not working atm because we dont have 'entry.rule-number' filter
#       in DescribeNetworkAcls

resource "aws_network_acl_rule" "test_rule" {
  network_acl_id = "${aws_network_acl.test_network_acl.id}"
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 22
  to_port        = 22
  cidr_block     = "${aws_subnet.test_subnet.cidr_block}"
}
