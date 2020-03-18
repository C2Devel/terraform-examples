resource "aws_default_security_group" "default_security_group" {
  # NOTE: for more information check 'aws_security_group' case
  vpc_id = aws_vpc.test_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
}
