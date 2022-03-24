resource "aws_launch_template" "launch_template" {
  name = "test_launch_template"
  image_id = var.ami
  instance_type = var.instance_type
}
