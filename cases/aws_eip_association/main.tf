resource "aws_instance" "test_instance" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.test_subnet.id}"
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_eip_association" "eip_association" {
  # NOTE: 'private_ip' attributes is not supported.
  instance_id = "${aws_instance.test_instance.id}"

  allocation_id = "${aws_eip.eip.id}"
}
