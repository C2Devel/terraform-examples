resource "aws_network_interface" "test" {
  # NOTE: 'security_groups', 'attachment',
  #       'private_ips', 'private_ips_count'
  #       attributes are not supported.

  subnet_id = "${aws_subnet.test_subnet.id}"
  description = "test description"
  source_dest_check = true
}
