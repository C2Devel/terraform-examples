variable "subnet_id" {}

resource "aws_ami" "test_ami_with_cdrom" {
  # NOTE: 'name' attribute is not supported, leave blank
  name             = ""
  root_device_name = "cdrom1"

  # NOTE: 'virtualization_type' attribute must be overrided
  #       with 'kvm-virtio' or 'kvm-legacy' value
  virtualization_type = "kvm-virtio"

  # NOTE: 'sriov_net_support' attribute is not supported, leave blank
  sriov_net_support = ""

  # NOTE: empty 'cdrom' and 'floppy' slots
  #       must be created as 'ephemeral' block devices
  ephemeral_block_device = {
    device_name  = "cdrom1"
    virtual_name = "cdrom1"
  }

  ebs_block_device = {
    device_name = "disk1"
    volume_size = 5
  }
}

resource "aws_instance" "test_instance_with_cdrom" {
  ami           = "${aws_ami.test_ami_with_cdrom.id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
}
