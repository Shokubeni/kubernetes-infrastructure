resource "aws_vpc" "main" {
  cidr_block           = "${var.virtual_cloud_cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    ignore_changes = ["*"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Cluster VPC",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  lifecycle {
    ignore_changes = ["*"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Default Table",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    description = "All traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = ["*"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Default Group",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  lifecycle {
    ignore_changes = ["*"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Network ACL",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}