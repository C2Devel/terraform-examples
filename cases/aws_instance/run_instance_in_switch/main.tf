resource "aws_network_interface" "test_interface" {
  # NOTE: in this case `false` is only valid option
  #       for `source_dest_check` attribute
  subnet_id = var.switch_id

  source_dest_check = false
}

resource "aws_instance" "test_instance" {
  ami = var.ami
  instance_type = var.instance_type
  network_interface {
    network_interface_id = aws_network_interface.test_interface.id
    device_index         = 0
  }
}
