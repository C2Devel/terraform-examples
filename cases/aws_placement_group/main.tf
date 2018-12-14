resource "aws_placement_group" "test_placement_group" {
  name = "test_placement_group"

  # NOTE: the only supported value for 'strategy' attribute is 'distribute'
  strategy = "distribute"
}
