resource "aws_network_interface" "test_interface" {
  subnet_id = aws_subnet.test_subnet.id
}

resource "aws_instance" "test_instance_with_existing_network_interface" {
  ami = var.ami
  instance_type = var.instance_type
  network_interface {
    network_interface_id = aws_network_interface.test_interface.id
    device_index         = 0
  }
}
