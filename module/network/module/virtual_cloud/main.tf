resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} Cluster VPC",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} Default Table",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} Default Group",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} Network ACL",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}