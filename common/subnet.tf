variable "subnets_count" {
  default = 1
}

resource "aws_subnet" "test_subnet" {
  count  = "${var.subnets_count}"
  vpc_id = "${aws_vpc.test_vpc.id}"

  cidr_block = "${
    cidrsubnet(aws_vpc.test_vpc.cidr_block,
    ceil(log(var.subnets_count, 2)),
    count.index)
  }"
}
