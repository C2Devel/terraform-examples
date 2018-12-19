resource "aws_instance" "test_instance_attachment" {
  availability_zone = "${var.az}"
  ami               = "${var.ami}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${aws_subnet.test_subnet.id}"
}

resource "aws_ebs_volume" "test_attach_volume" {
  availability_zone = "${var.az}"
  size              = 32
}

resource "aws_volume_attachment" "test_ebs_attachment" {
  # NOTE: 'skip_destroy' attribute is not supported
  device_name  = "disk2"
  volume_id    = "${aws_ebs_volume.test_attach_volume.id}"
  instance_id  = "${aws_instance.test_instance_attachment.id}"
  force_detach = true
}
