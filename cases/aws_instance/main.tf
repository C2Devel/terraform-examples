resource "aws_security_group" "additional_security_group" {
  name        = "additional_security_group"
  description = "additional_security_group"
  vpc_id      = "${aws_vpc.test_vpc.id}"
}

resource "aws_key_pair" "test_key_pair" {
  key_name   = "terraform_key"
  public_key = "${var.material}"
}

resource "aws_placement_group" "test_placement_group" {
  name     = "test_placement_group"
  strategy = "spread"
}

resource "aws_instance" "test_instance" {
  # NOTE: 'tenancy', 'host_id', 'cpu_core_count', 'cpu_threat_per_code',
  #       'ebs_optimized', 'get_password_data', 'monitoring', 'iam_instance_profile',
  #       'ipv6_address_count', 'ipv6_addresses', 'volume_tags', 'network_interface',
  #       'credit_specification' attributes are not supported.
  ami = "${var.ami}"

  availability_zone                    = "${var.az}"
  placement_group                      = "${aws_placement_group.test_placement_group.id}"
  associate_public_ip_address          = true
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "${var.instance_type}"
  key_name                             = "${aws_key_pair.test_key_pair.key_name}"
  monitoring                           = true
  vpc_security_group_ids               = ["${aws_security_group.test_security_group.id}", "${aws_security_group.additional_security_group.id}"]
  subnet_id                            = "${aws_subnet.test_subnet.id}"
  private_ip                           = "${cidrhost(aws_subnet.test_subnet.cidr_block, 3)}"
  source_dest_check                    = true
  user_data                            = "echo hello"
}
