resource "aws_instance" "test_instance" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.test_subnet.id}"
}

resource "aws_eip" "eip1" {
  # NOTE: 'network_interface' and 'public_ipv4_pull' is not supported.
  instance = "${aws_instance.test_instance.id}"

  vpc = true
}

resource "aws_instance" "test_instance2" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.test_subnet.id}"
  private_ip    = "${cidrhost(aws_subnet.test_subnet.cidr_block, 100)}"
}

resource "aws_eip" "eip2" {
  # NOTE: 'network_interface' and 'public_ipv4_pull' is not supported.
  vpc = true

  instance                  = "${aws_instance.test_instance2.id}"
  associate_with_private_ip = "${aws_instance.test_instance2.private_ip}"
}
