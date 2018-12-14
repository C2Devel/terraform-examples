resource "aws_ebs_volume" "test_volume" {
  availability_zone = "${var.az}"
  size              = 32
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = "${aws_ebs_volume.test_volume.id}"
}

resource "aws_ami" "test_ami" {
  name = "test_ami"

  # NOTE: 'virtualization_type' attribute must be overridden
  #       with 'kvm-virtio' or 'kvm-legacy' value
  virtualization_type = "kvm-virtio"

  root_device_name = "disk1"

  ebs_block_device {
    device_name = "disk1"
    snapshot_id = "${aws_ebs_snapshot.test_snapshot.id}"
  }
}

resource "aws_ami_launch_permission" "test_ami_launch" {
  image_id = "${aws_ami.test_ami.id}"

  # NOTE: specify 'account_id' as 'project_name' and 'customer_name' pair
  account_id = "${var.account_id}"
}
