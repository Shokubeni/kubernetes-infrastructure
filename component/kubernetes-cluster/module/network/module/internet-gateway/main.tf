resource "aws_internet_gateway" "internet" {
  vpc_id = var.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_data.name} Internet Gateway",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_route_table" "internet" {
  vpc_id = var.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_data.name} Internet Table",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.internet.id
  gateway_id             = aws_internet_gateway.internet.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnets_ids)
  subnet_id      = var.subnets_ids[count.index]
  route_table_id = aws_route_table.internet.id
}