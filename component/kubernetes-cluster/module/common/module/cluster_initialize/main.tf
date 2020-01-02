locals {
  name       = var.cluster_name
  label      = var.cluster_label
}

data "aws_caller_identity" "default" {}
data "aws_region" "default" {}

resource "random_id" "cluster" {
  byte_length = 8
}
