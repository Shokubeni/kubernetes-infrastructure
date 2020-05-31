resource "random_id" "cluster_identity" {
  byte_length = 8
}

data "aws_caller_identity" "default" {}

data "aws_region" "default" {}