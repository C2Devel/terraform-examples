resource "aws_vpc" "test_vpc" {
  # NOTE: 'instance_tenancy', 'enable_classiclink',
  #       'enable_classiclink_dns_support', 'assign_generated_ipv6_cidr_block'
  #        attributes is not supported.
  cidr_block = "192.168.10.0/24"

  enable_dns_support   = false
  enable_dns_hostnames = false
}
