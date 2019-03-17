locals {
  name       = "${lookup(var.cluster_config, "name", "SmartGears")}"
  label      = "${lookup(var.cluster_config, "label", "smart-gears")}"
  kubernetes = "1.13.3"
  docker     = "18.06.0"
}

data "aws_caller_identity" "default" {}
data "aws_region" "default" {}

resource "random_id" "cluster" {
  byte_length = 8
}