# NOTE: currently unsupported
resource "aws_default_vpc_dhcp_options" "default_vpc_dhcp_options" {
  netbios_name_servers = ["127.0.0.1"]
  netbios_node_type    = 2
}
