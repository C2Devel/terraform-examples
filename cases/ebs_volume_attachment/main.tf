variable "subnet_id" {}

resource "aws_instance" "test_instance_attachment" {
  ami           = "${aws_ami.test_ami.id}"
  instance_type = "m1.micro"
  subnet_id     = "${var.subnet_id}"
}

resource "aws_ebs_volume" "test_attach_volume" {
  availability_zone = "${var.az}"
  size              = 5
}

resource "aws_volume_attachment" "test_ebs_attachment" {
  device_name = "disk2"
  volume_id   = "${aws_ebs_volume.test_attach_volume.id}"
  instance_id = "${aws_instance.test_instance_attachment.id}"
}
