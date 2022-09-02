resource "aws_default_vpc" "default_vpc" {
  # NOTE: 'enable_classiclink' and 'enable_dns_hostnames'
  #       attributes are not supported
  enable_dns_support = false
  enable_classiclink = false
  tags = {
    Name = "Default VPC"
  }
}
