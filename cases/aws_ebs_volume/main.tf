variable "types" {
  default = ["gp2", "st2"]
}

resource "aws_ebs_volume" "test_volume_iops" {
  # NOTE: 'encrypted', 'kms_key_id' attributes are not supported.
  #       'gp2' and 'st2' are valid values for 'type' attribute.
  #       'iops = "400"' is only possible iops specification
  #       for disks with 'st2' volume type. Disks with 'st2'
  #       volume type must have size attribute value more then '32G'.
  count = length(var.types)

  availability_zone = var.az

  size = 32
  type = var.types[count.index]
  iops = "400"
}
