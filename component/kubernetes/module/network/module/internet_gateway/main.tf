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

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet.id}"
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Internet Table",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_route_table_association" "internet" {
  count          = "${var.subnets_count}"
  subnet_id      = "${element(var.subnets_ids, count.index)}"
  route_table_id = "${aws_route_table.internet.id}"
}