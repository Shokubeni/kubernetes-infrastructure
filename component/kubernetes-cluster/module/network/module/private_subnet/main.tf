resource "aws_subnet" "private" {
  count             = var.subnets_count
  availability_zone = var.subnets_zones[count.index]
  cidr_block        = var.subnets_cidrs[count.index]
  vpc_id            = var.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_config.name} Private Subnet",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}
