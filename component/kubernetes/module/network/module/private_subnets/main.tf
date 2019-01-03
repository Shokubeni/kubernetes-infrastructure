resource "aws_subnet" "private" {
  count             = "${length(var.subnets_cidrs)}"
  availability_zone = "${element(var.subnets_zones, count.index)}"
  cidr_block        = "${element(var.subnets_cidrs, count.index)}"
  vpc_id            = "${var.virtual_cloud_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Private Subnet",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_config["label"]}", "owned"
    )
  )}"
}
