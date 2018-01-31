variable "subnet_id" {}

resource "aws_instance" "test_instance_removed_cdrom" {
  ami           = "${aws_ami.test_ami_with_cdrom.id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"

  # NOTE: 'root_block_device' section is required for
  #       proper detection of the instance root device
  ebs_block_device {
    device_name           = "disk1"
    volume_size           = 15
    delete_on_termination = false
  }

  # NOTE: Any additional block devices must be
  #       defined in 'ebs_block_device' section
  ephemeral_block_device {
    device_name = "cdrom1"
    no_device   = true
  }
}
