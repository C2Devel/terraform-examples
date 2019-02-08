resource "aws_ebs_volume" "test_volume" {
  availability_zone = "${var.az}"
  size              = 32
}

resource "aws_ebs_snapshot" "test_snapshot" {
  description = "test description"
  volume_id   = "${aws_ebs_volume.test_volume.id}"
}
