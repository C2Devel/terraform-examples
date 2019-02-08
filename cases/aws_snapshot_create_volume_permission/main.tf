resource "aws_ebs_volume" "test_volume" {
  availability_zone = "${var.az}"
  size              = 32
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = "${aws_ebs_volume.test_volume.id}"
}

resource "aws_snapshot_create_volume_permission" "test_volume_permission" {
  snapshot_id = "${aws_ebs_snapshot.test_snapshot.id}"

  # NOTE: specify 'account_id' as 'project_name' and 'customer_name' pair
  account_id = "${var.account_id}"
}
