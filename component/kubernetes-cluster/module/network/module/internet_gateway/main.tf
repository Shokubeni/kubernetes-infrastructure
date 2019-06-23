resource "aws_internet_gateway" "internet" {
  vpc_id = var.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_config.name} Internet Gateway",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_route_table" "internet" {
  vpc_id = var.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_config.name} Internet Table",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.internet.id
  gateway_id             = aws_internet_gateway.internet.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnets_count
  subnet_id      = var.public_subnets_ids[count.index]
  route_table_id = aws_route_table.internet.id
}