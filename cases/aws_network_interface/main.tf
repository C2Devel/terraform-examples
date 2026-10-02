resource "aws_network_interface" "test" {
  description       = "test description"
  private_ips_count = 2
  security_groups   = [aws_security_group.test_security_group.id]
  source_dest_check = true
  subnet_id         = aws_subnet.test_subnet.id
}
