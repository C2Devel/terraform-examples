variable "rule_types" {
  type    = "list"
  default = ["ingress", "egress"]
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}

resource "aws_security_group_rule" "allow_all" {
  count             = "${length(var.rule_types)}"
  type              = "${element(var.rule_types, count.index)}"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_default_security_group.default_security_group.id}"
}
