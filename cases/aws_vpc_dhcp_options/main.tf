resource "aws_vpc_dhcp_options" "test_dhcp_options" {
  domain_name          = "service.consul"
  domain_name_servers  = ["8.8.8.8", "8.8.4.4"]
  ntp_servers          = ["127.0.0.1"]
  netbios_name_servers = ["127.0.0.1"]
  netbios_node_type    = 2
}
