resource "aws_ebs_volume" "test_volume" {
  availability_zone = "${var.az}"
  size              = 32
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = "${aws_ebs_volume.test_volume.id}"
}

resource "aws_ami" "test_ami" {
  name = "test-image"

  # NOTE: 'virtualization_type' attribute must be overrided
  #       with 'kvm-virtio' or 'kvm-legacy' value
  virtualization_type = "kvm-virtio"

  # NOTE: 'sriov_net_support' attribute is not supported, leave blank
  sriov_net_support = ""
  root_device_name  = "disk1"

  ebs_block_device {
    device_name = "disk1"
    snapshot_id = "${aws_ebs_snapshot.test_snapshot.id}"
  }
}
