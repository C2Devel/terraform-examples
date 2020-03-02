resource "aws_ami" "test_ami_with_cdrom" {
  name             = "test_ami"
  root_device_name = "cdrom1"

  # NOTE: 'virtualization_type' attribute must be overridden
  #       with 'kvm-virtio' or 'kvm-legacy' value
  virtualization_type = "kvm-virtio"

  # NOTE: empty 'cdrom' and 'floppy' slots
  #       must be created as 'ephemeral' block devices
  ephemeral_block_device {
    device_name  = "cdrom1"
    virtual_name = "cdrom1"
  }

  ebs_block_device {
    device_name = "disk1"
    volume_type = "st2"
    volume_size = 32
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

resource "aws_instance" "test_instance_with_cdrom" {
  ami           = aws_ami.test_ami_with_cdrom.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.test_subnet.id
}
