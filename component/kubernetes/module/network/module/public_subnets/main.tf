resource "aws_subnet" "public" {
  count             = "${length(var.subnets_cidrs)}"
  availability_zone = "${element(var.subnets_zones, count.index)}"
  cidr_block        = "${element(var.subnets_cidrs, count.index)}"
  vpc_id            = "${var.vpc_id}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_info["name"]} Public Subnet",
      "Environment", "${terraform.workspace}",
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned"
    )
  )}"
}