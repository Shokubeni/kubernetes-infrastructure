locals {
  modificator = "${var.use_nat_gateways == "false" ? 1 : 0}"
}

resource "aws_internet_gateway" "internet" {
  vpc_id = "${var.virtual_cloud_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Internet Gateway",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_route_table" "internet" {
  vpc_id = "${var.virtual_cloud_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Internet Table",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_route" "internet" {
  route_table_id         = "${aws_route_table.internet.id}"
  gateway_id             = "${aws_internet_gateway.internet.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = "${var.public_subnets_count}"
  subnet_id      = "${element(var.public_subnets_ids, count.index)}"
  route_table_id = "${aws_route_table.internet.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${var.private_subnets_count * local.modificator}"
  subnet_id      = "${element(var.private_subnets_ids, count.index)}"
  route_table_id = "${aws_route_table.internet.id}"
}