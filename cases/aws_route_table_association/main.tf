resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.route_table.id
}
