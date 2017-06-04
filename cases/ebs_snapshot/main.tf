resource "aws_ebs_snapshot" "test_snapshot_from_volume" {
  volume_id = "${aws_ebs_volume.test_volume.id}"
}

resource "aws_ebs_volume" "test_volume_from_snapshot" {
  availability_zone = "${var.az}"
  snapshot_id       = "${aws_ebs_snapshot.test_snapshot_from_volume.id}"
}
