resource "aws_subnet" "test_subnet" {
  availability_zone = var.az
  vpc_id            = aws_vpc.test_vpc.id

  cidr_block = cidrsubnet(aws_vpc.test_vpc.cidr_block, 1, 0)
}

