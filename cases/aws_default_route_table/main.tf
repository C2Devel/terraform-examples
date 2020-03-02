resource "aws_default_route_table" "default_route_table" {
  # NOTE: 'propagating_vgws' attribute is not supported.
  #       Current resource cant be destroyed properly.
  #       For more information check 'aws_route_table' case.
  default_route_table_id = aws_vpc.test_vpc.default_route_table_id
}
