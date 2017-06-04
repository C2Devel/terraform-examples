variable material {}

resource "aws_key_pair" "test_key_pair" {
  key_name   = "test_key_pair"
  public_key = "${var.material}"
}
