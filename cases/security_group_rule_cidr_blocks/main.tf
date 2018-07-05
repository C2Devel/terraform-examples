# NOTE: We are describing SG rules differently than
#       it doing AWS; We are returning all rules separately
#       rather than grouping them by port range, protocol
#       and type; Workaround is to create separate rule
#       for every cidr block;

resource "aws_security_group_rule" "allow_all" {
  count             = "${var.subnets_count}"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${element(aws_subnet.test_subnet.*.cidr_block, count.index)}"]
  security_group_id = "${aws_security_group.test_security_group.id}"
}
