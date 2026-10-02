resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    # NOTE: 'ipv6_cidr_block', 'egress_only_gateway_id', 'vpc_peering_connection_id'
    #       attributes are not supported for inline route object.
    cidr_block = "10.0.2.0/24"
    network_interface_id = aws_network_interface.test.id
  }

  route {
    cidr_block = "10.0.3.0/24"
    instance_id = aws_instance.test.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id

    # NOTE: If internet access is required only for instances with Elastic IP
    # addresses, then you can use an Internet gateway instead of a NAT gateway:
    # gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_instance" "test" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.test_subnet.id
}

resource "aws_network_interface" "test" {
  subnet_id = aws_subnet.test_subnet.id
}
