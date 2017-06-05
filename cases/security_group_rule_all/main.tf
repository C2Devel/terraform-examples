variable subnet_id {}

resource "aws_security_group_rule" "allow_all" {
  # NOTE: the only 'ingress' rules is currently supported
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  # NOTE: 'subnet_id' can be specified instead of 'security_groups_id'
  security_group_id = "${var.subnet_id}"
}
