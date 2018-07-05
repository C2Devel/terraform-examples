variable "rule_types" {
  type    = "list"
  default = ["ingress", "egress"]
}

resource "aws_security_group_rule" "test_rule" {
  count     = "${length(var.rule_types)}"
  type      = "${var.rule_types[count.index]}"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"

  source_security_group_id = "${
    element(aws_security_group.test_security_group.*.id, 1)
  }"

  security_group_id = "${
    element(aws_security_group.test_security_group.*.id, 0)
  }"
}
