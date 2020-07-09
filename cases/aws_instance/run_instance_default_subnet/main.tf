resource "aws_instance" "test_instance_default_subnet" {
  ami           = var.ami
  instance_type = var.instance_type
}
