variable "vpcs_count" {
  default = 1
}

resource "aws_vpc" "test_vpc" {
  count      = "${var.vpcs_count}"
  cidr_block = "192.168.10.0/24"
}
