resource "aws_snapshot_create_volume_permission" "test_volume_permission" {
  snapshot_id = "${aws_ebs_snapshot.test_snapshot.id}"

  # NOTE: specify 'account_id' as 'project_name' and 'customer_name' pair
  account_id = "p1@hc.cloud.croc.ru"
}
