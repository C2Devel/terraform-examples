resource "aws_instance" "test_instance_with_override" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.test_subnet.id

  # NOTE: 'root_block_device' section is required for
  #       proper detection of the instance root device
  root_block_device {
    volume_size           = 32
    delete_on_termination = false
  }

  # NOTE: Any additional block devices must be
  #       defined in 'ebs_block_device' section
  ebs_block_device {
    device_name = "disk2"
    volume_size = 32
  }

  ebs_block_device {
    device_name = "disk3"
    volume_size = 15
    volume_type = "io1"
    iops        = 1000
  }
}
