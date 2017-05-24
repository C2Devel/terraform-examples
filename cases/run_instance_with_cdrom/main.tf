variable "subnet_id" {}

resource "aws_ami" "test_ami_with_cdrom" {
  # must be empty, due to 'name' field is not supported
  name             = ""
  root_device_name = "cdrom1"

  # must be overrided, due to 'paravirtualized' is not supported
  virtualization_type = "kvm-virtio"

  # must be empty, due to 'simple' is not supported
  sriov_net_support = ""

  /* Empty 'cdrom' and 'floppy' slots must be created as 'ephemeral' block devices */
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
  instance_type = "m1.micro"
  subnet_id     = "${var.subnet_id}"
}
