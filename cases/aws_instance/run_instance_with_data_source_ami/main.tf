data "aws_ami" "test_data_ami" {
  most_recent      = true
  owners           = [var.template_owner]   # This option is required, for example you can use ["self"] for your images.

# You can use different filters, for example "name", "description", "image_id", "tag".
  filter {
    name   = "name"
    values = [var.template_name]
  }
}

resource "aws_instance" "test_instance" {
  # NOTE: 'tenancy', 'host_id', 'cpu_core_count', 'cpu_threat_per_code',
  #       'ebs_optimized', 'get_password_data', 'monitoring', 'iam_instance_profile',
  #       'ipv6_address_count', 'ipv6_addresses', 'network_interface',
  #       'credit_specification', 'private_ip' attributes are not supported.

  ami                                  = data.aws_ami.test_data_ami.id
  availability_zone                    = var.az
  instance_type                        = var.instance_type
  vpc_security_group_ids               = [ aws_security_group.test_security_group.id ]
  subnet_id                            = aws_subnet.test_subnet.id
}
