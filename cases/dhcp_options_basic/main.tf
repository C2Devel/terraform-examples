resource "aws_default_vpc" "test_default_vpc" {
  enable_dns_support = false
}

resource "aws_vpc_dhcp_options" "test_dhcp_options" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}

resource "aws_vpc_dhcp_options_association" "test_dhcp_options_assoc" {
  vpc_id          = "${aws_default_vpc.test_default_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.test_dhcp_options.id}"
}
