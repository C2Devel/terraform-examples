resource "aws_ebs_volume" "test_volume" {
  availability_zone = "${var.az}"
  size              = 10
}
