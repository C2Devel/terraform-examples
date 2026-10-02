resource "aws_vpc" "first_test_vpc" {
  cidr_block = "192.168.10.0/24"
}

resource "aws_subnet" "first_test_subnet_instance" {
  availability_zone = var.az
  vpc_id            = aws_vpc.first_test_vpc.id

  cidr_block = cidrsubnet(aws_vpc.first_test_vpc.cidr_block, 1, 0)
}

resource "aws_subnet" "first_test_subnet_transit" {
  availability_zone = var.az
  vpc_id            = aws_vpc.first_test_vpc.id

  cidr_block = cidrsubnet(aws_vpc.first_test_vpc.cidr_block, 1, 1)
}
