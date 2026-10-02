resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "test_tgw"
  default_route_table_propagation = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "first_tgw_vpc_attachment" {
  subnet_ids         = [aws_subnet.first_test_subnet_transit.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.first_test_vpc.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "second_tgw_vpc_attachment" {
  subnet_ids         = [aws_subnet.second_test_subnet_transit.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.second_test_vpc.id
}

resource "aws_route" "first_vpc_route" {
  destination_cidr_block = "192.168.20.0/24"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  route_table_id         = aws_vpc.first_test_vpc.main_route_table_id
}

resource "aws_route" "second_vpc_route" {
  destination_cidr_block = "192.168.10.0/24"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  route_table_id         = aws_vpc.second_test_vpc.main_route_table_id
}
