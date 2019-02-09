locals {
  modificator = "${var.use_nat_gateways == "true" ? 1 : 0}"
}

resource "aws_eip" "nat" {
  count = "${var.private_subnets_count * local.modificator}"
  vpc = true

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} NAT Elastic IP",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_nat_gateway" "nat" {
  count         = "${var.private_subnets_count * local.modificator}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${
    var.private_subnets_count >= var.private_subnets_count
      ? element(var.public_subnets_ids, count.index)
      : var.public_subnets_ids[0]
  }"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} NAT Gateway",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_route_table" "nat" {
  count  = "${var.private_subnets_count * local.modificator}"
  vpc_id = "${var.virtual_cloud_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} NAT Table",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_route" "nat" {
  count                  = "${var.private_subnets_count * local.modificator}"
  route_table_id         = "${element(aws_route_table.nat.*.id, count.index)}"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "nat" {
  count          = "${var.private_subnets_count * local.modificator}"
  subnet_id      = "${element(var.private_subnets_ids, count.index)}"
  route_table_id = "${element(aws_route_table.nat.*.id, count.index)}"
}