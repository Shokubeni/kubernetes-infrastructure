resource "aws_eip" "nat" {
  count = "${length(var.subnets_count)}"
  vpc = true

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} NAT Elastic IP",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_nat_gateway" "nat" {
  count         = "${length(var.subnets_count)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(var.subnets_ids, count.index)}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} NAT Gateway",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_route_table" "nat" {
  count  = "${length(var.subnets_count)}"
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} NAT Table",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_route_table_association" "nat" {
  count          = "${length(var.subnets_count)}"
  subnet_id      = "${element(var.subnets_ids, count.index)}"
  route_table_id = "${element(aws_route_table.nat.*.id, count.index)}"
}