resource "aws_ami_launch_permission" "test_ami_launch" {
  image_id   = "${aws_ami.test_ami.id}"
  account_id = "p1@hc.cloud.croc.ru"
}
