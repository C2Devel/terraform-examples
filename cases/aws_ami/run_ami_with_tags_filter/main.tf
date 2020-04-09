resource "aws_ebs_volume" "test_volume" {
  availability_zone = var.az
  size              = 32
  tags = {
      VolTag = "vol-tag"    # key = VolTag, Values = vol-tag
    }
}

data "aws_ebs_volume" "data-volume" {
  most_recent = true    # If search has a few result, the newer will be choose

  depends_on = [
    aws_ebs_volume.test_volume
  ]

  filter {
    name   = "tag:VolTag"
    values = ["vol-tag"]
  }
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id   = data.aws_ebs_volume.data-volume.id
  tags = {
      SnapTag = "snap-tag"  # key = SnapTag, Values = snap-tag
    }
}

data "aws_ebs_snapshot" "data-snap" {
  most_recent = true
  owners      = ["self"]

  depends_on = [
    aws_ebs_snapshot.test_snapshot
  ]

  filter {
    name   = "tag:SnapTag"
    values = ["snap-tag"]
  }
}

resource "aws_ami" "test_ami_from_snapshot" {
  # NOTE: 'ena_support' attribute is not supported.
  #       'architecture' attribute is not supported.
  name = "test_ami"

  description = "test_ami_description"

  # NOTE: 'virtualization_type' attribute must be overridden
  #       with 'kvm-virtio' or 'kvm-legacy' value
  virtualization_type = "kvm-virtio"

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
    device_name = "disk1"

    snapshot_id = data.aws_ebs_snapshot.data-snap.id
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}
