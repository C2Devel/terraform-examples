resource "aws_instance" "test_instance" {
  # NOTE: add custom code to switch instance
  #       to 'stopped' state
  ami = "${var.ami}"

  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.test_subnet.id}"
}

resource "aws_ami_from_instance" "test_ami" {
  # NOTE: 'snapshot_without_reboot' attribute is not supported.
  name = "test_ami"

  source_instance_id = "${aws_instance.test_instance.id}"
}
