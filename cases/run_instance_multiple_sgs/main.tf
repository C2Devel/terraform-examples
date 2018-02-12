resource "aws_instance" "test_instance" {
  ami            = "${aws_ami.test_ami.id}"
  instance_type  = "${var.instance_type}"
  security_group = ["${aws_security_group.test_security_group.*.id}"]

  # TODO: Change 'security_group' to 'vpc_security_group_ids' 
  #       after implementing NetworkInterfaces API. ATM instanse
  #       is recreating on every apply.
  # vpc_security_group_ids = ["${aws_security_group.test_security_group.*.id}"]
  subnet_id = "${aws_subnet.test_subnet.id}"
}
