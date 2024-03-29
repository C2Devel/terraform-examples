resource "aws_ebs_volume" "test_volume" {
  availability_zone = var.az
  size              = 32
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = aws_ebs_volume.test_volume.id
}

resource "aws_ami" "test_ami_from_snapshot" {
  # NOTE: 'ena_support' attribute is not supported.
  #       'architecture' attribute is not supported.
  name = "test_ami"

  description = "test_description"

  # NOTE: 'virtualization_type' attribute must be overridden
  #       with 'hvm' value
  virtualization_type = "hvm"

  root_device_name = "disk1"

  ephemeral_block_device {
    # NOTE: 'cdrom<N>' and 'floppy<N>' values is supported for
    #       'device_name' and 'virtual_name' attributes
    device_name = "cdrom1"

    virtual_name = "cdrom1"
  }

  ebs_block_device {
    # NOTE: for list of supported attributes check
    #       'aws_ebs_volume' case.
    #       'kms_key_id' attribute is not supported
    #
    #       The 'volume_type' must be defined from the supported types ['st2', 'gp2', 'io2']
    volume_type = "st2"
    device_name = "disk1"
    snapshot_id = aws_ebs_snapshot.test_snapshot.id
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}
