resource "aws_route" "default_route" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
  route_table_id         = aws_vpc.test_vpc.main_route_table_id
}
