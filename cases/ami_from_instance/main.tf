variable "instance_id" {}

resource "aws_ami_from_instance" "test_ami" {
  # NOTE: 'name' attribute is not supported, leave blank
  name               = ""
  source_instance_id = "${var.instance_id}"
}
