variable "subnet_id" {}

resource "aws_placement_group" "test_placement_group" {
  name     = "test_placement_group"
  strategy = "distribute"
}

resource "aws_instance" "test_instance_in_placement_group" {
  ami             = "${aws_ami.test_ami.id}"
  instance_type   = "${var.instance_type}"
  subnet_id       = "${var.subnet_id}"
  placement_group = "${aws_placement_group.test_placement_group.id}"
}
