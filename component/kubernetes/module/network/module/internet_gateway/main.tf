resource "aws_internet_gateway" "internet" {
  vpc_id = "${var.vpc_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} Internet Gateway",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_route_table" "internet" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet.id}"
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} Internet Table",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}

resource "aws_route_table_association" "internet" {
  count          = "${length(var.subnets_count)}"
  subnet_id      = "${element(var.subnets_ids, count.index)}"
  route_table_id = "${aws_route_table.internet.id}"
}