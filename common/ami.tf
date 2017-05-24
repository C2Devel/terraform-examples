resource "aws_ebs_volume" "test_volume" {
  availability_zone = "${var.az}"
  size              = 10
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = "${aws_ebs_volume.test_volume.id}"
}

resource "aws_ami" "test_ami" {
  name                = ""
  virtualization_type = "kvm-virtio"
  sriov_net_support   = ""
  root_device_name    = "disk1"

  ebs_block_device {
    device_name = "disk1"
    snapshot_id = "${aws_ebs_snapshot.test_snapshot.id}"
  }
}
