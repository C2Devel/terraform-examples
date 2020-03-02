resource "tls_private_key" "ssh" {
  algorithm   = "RSA"
}

resource "aws_key_pair" "test_key_pair_with_name_prefix" {
  key_name_prefix = "terraform"
  public_key      = tls_private_key.ssh.public_key_openssh
}

resource "aws_key_pair" "test_key_pair" {
  key_name   = "test_key_pair"
  public_key = tls_private_key.ssh.public_key_openssh
}
