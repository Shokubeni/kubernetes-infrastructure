resource "aws_subnet" "private" {
  count             = length(var.subnets_cidrs)
  availability_zone = var.subnets_zones[count.index]
  cidr_block        = var.subnets_cidrs[count.index]
  vpc_id            = var.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_data.name} Private Subnet",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}