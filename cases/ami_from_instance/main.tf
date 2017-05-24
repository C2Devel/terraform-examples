variable "subnet_id" {}
variable "instance_id" {}

resource "aws_ami_from_instance" "test_ami" {
  name               = ""
  source_instance_id = "${var.instance_id}"
}
