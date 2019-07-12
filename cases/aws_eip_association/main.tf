resource "aws_instance" "test" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.test_subnet.id}"
}

resource "aws_eip" "test1" {
  vpc = true
}

resource "aws_eip_association" "test1" {
  # NOTE: 'private_ip' attributes is not supported.
  instance_id = "${aws_instance.test.id}"

  allocation_id = "${aws_eip.test1.id}"
}

resource "aws_network_interface" "test" {
  subnet_id = "${aws_subnet.test_subnet.id}"
}

resource "aws_eip" "test2" {
  vpc = true
}

resource "aws_eip_association" "test2" {
  network_interface_id = "${aws_network_interface.test.id}"

  allocation_id = "${aws_eip.test2.id}"
}
