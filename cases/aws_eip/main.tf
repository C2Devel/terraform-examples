resource "aws_instance" "test1" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.test_subnet.id
}

resource "aws_eip" "test1" {
  instance = aws_instance.test1.id
}

resource "aws_network_interface" "test1" {
  subnet_id = aws_subnet.test_subnet.id
}

resource "aws_eip" "test2" {
  network_interface = aws_network_interface.test1.id
}
