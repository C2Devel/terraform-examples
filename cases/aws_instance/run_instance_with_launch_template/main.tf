resource "aws_launch_template" "test_launch_template" {
  name          = "test_launch_template"
  image_id      = var.ami
  instance_type = var.instance_type
}

resource "aws_instance" "test_instance_with_launch_template" {
  launch_template {
    name    = aws_launch_template.test_launch_template.name
    version = "$Latest"
  }
}
