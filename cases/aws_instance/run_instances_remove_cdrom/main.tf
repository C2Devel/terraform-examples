resource "aws_ami" "test_ami" {
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

resource "aws_instance" "test_instance" {
  ami           = aws_ami.test_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.test_subnet.id

  # NOTE: 'root_block_device' section is required for
  #       proper detection of the instance root device
  root_block_device {
    volume_type = "st2"
  }

  ebs_block_device {
    device_name           = "disk1"
    volume_size           = 32
    delete_on_termination = false
  }

  # NOTE: Any additional block devices must be
  #       defined in 'ebs_block_device' section
  ephemeral_block_device {
    device_name  = "cdrom1"
    virtual_name = "cdrom1"
    no_device    = true
  }
}

