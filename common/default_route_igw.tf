resource "aws_route" "default_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_vpc.test_vpc.main_route_table_id
}
