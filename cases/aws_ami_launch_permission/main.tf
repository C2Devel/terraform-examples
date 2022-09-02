resource "aws_ebs_volume" "test_volume" {
  availability_zone = var.az
  size              = 32
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = aws_ebs_volume.test_volume.id
}

resource "aws_ami" "test_ami" {
  name = "test_ami"

  # NOTE: 'virtualization_type' attribute must be overridden
  #       with 'hvm' value
  virtualization_type = "hvm"

  root_device_name = "disk1"

  ebs_block_device {
    # NOTE:
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

resource "aws_ami_launch_permission" "test_ami_launch" {
  image_id = aws_ami.test_ami.id

  # NOTE: specify 'account_id' as 'customer_name'
  account_id = var.account_id
}
