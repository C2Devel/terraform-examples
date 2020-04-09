resource "tls_private_key" "ssh" {
  algorithm   = "RSA"
}

resource "aws_security_group" "additional_security_group" {
  name        = "additional_security_group"
  description = "additional_security_group"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_key_pair" "test_key_pair" {
  key_name   = "terraform_key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_placement_group" "test_placement_group" {
  name     = "test_placement_group"
  strategy = "spread"
}

data "aws_ami" "test_data_ami" {
  most_recent      = true
  owners           = ["images@cloud.croc.ru"]   # This option is required, for example you can use ["self"] for your images.

# You can use different filters, for example "name", "description", "image_id", "tag".
  filter {
    name   = "image-id"
    values = ["cmi-3AF36990"]
  }
}

resource "aws_instance" "test_instance" {
  # NOTE: 'tenancy', 'host_id', 'cpu_core_count', 'cpu_threat_per_code',
  #       'ebs_optimized', 'get_password_data', 'monitoring', 'iam_instance_profile',
  #       'ipv6_address_count', 'ipv6_addresses', 'network_interface',
  #       'credit_specification', 'private_ip' attributes are not supported.
  ami = data.aws_ami.test_data_ami.id

  availability_zone                    = var.az
  placement_group                      = aws_placement_group.test_placement_group.id
  associate_public_ip_address          = true
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = aws_key_pair.test_key_pair.key_name
  monitoring                           = true
  vpc_security_group_ids               = [aws_security_group.test_security_group.id, aws_security_group.additional_security_group.id]
  subnet_id                            = aws_subnet.test_subnet.id
  source_dest_check                    = true
  user_data                            = "echo hello"
}
