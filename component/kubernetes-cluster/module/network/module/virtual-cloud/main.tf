resource "aws_vpc" "main" {
  cidr_block           = var.virtual_cloud_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Name" = "${var.cluster_data.name} Cluster VPC",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Name" = "${var.cluster_data.name} Default Table",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

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
    ignore_changes = all
  }

  tags = {
    "Name" = "${var.cluster_data.name} Default Group",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

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
    ignore_changes = all
  }

  tags = {
    "Name" = "${var.cluster_data.name} Network ACL",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}
