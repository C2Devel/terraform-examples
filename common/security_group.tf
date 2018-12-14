resource "aws_security_group" "test_security_group" {
  name        = "test_security_group"
  description = "test_security_group"
  vpc_id      = "${aws_vpc.test_vpc.id}"
}
