resource "aws_subnet" "test_subnet" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  cidr_block = "${cidrsubnet(aws_vpc.test_vpc.cidr_block, 1, 0)}"
}
