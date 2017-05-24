variable "subnet_id" {}

resource "aws_instance" "test_instance_with_io1" {
  ami           = "${aws_ami.test_ami.id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"

  root_block_device {
    volume_size = 15
    volume_type = "io1"
    iops        = 1000
  }
}
