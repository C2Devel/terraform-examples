resource "aws_vpc" "test_vpc" {
  cidr_block = "192.168.10.0/24"
}

resource "aws_subnet" "test_subnet_one" {
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "192.168.10.0/28"
}

resource "aws_subnet" "test_subnet_two" {
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "192.168.10.32/28"
}
