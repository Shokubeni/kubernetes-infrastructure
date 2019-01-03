resource "aws_vpc" "main" {
  cidr_block           = "${var.virtual_cloud_cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Cluster VPC",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_config["label"]}", "owned"
    )
  )}"
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Default Table",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_config["label"]}", "owned"
    )
  )}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Default Group",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_config["label"]}", "owned"
    )
  )}"
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Network ACL",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_config["label"]}", "owned"
    )
  )}"
}