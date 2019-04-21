resource "aws_subnet" "public" {
  count             = "${var.subnets_count}"
  availability_zone = "${element(var.subnets_zones, count.index)}"
  cidr_block        = "${element(var.subnets_cidrs, count.index)}"
  vpc_id            = "${var.virtual_cloud_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Public Subnet",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}