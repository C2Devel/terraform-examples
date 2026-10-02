resource "aws_nat_gateway" "nat_gw" {
  depends_on = [aws_internet_gateway.igw]

  vpc_id = aws_vpc.test_vpc.id
}
