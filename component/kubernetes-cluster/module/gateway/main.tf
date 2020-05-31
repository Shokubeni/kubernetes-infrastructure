data "aws_ami" "nat" {
  owners = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }
}

resource "aws_network_interface" "nat" {
  count             = length(var.network_config.public_subnets)
  subnet_id         = var.network_data.public_subnet_ids[count.index]
  security_groups   = [var.nat_instance.group_id]
  source_dest_check = "false"

  tags = {
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_instance" "nat" {
  count                                = length(var.network_config.public_subnets)
  instance_type                        = var.network_config.nat_instance_type
  ami                                  = data.aws_ami.nat.id
  instance_initiated_shutdown_behavior = "stop"
  disable_api_termination              = "false"
  ebs_optimized                        = "false"
  monitoring                           = "false"

  root_block_device {
    delete_on_termination = "true"
    volume_type           = "gp2"
    volume_size           = 10
  }

  credit_specification {
    cpu_credits = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.nat.*.id[count.index]
    device_index         = 0
  }

  volume_tags = {
    "Name" = "${var.cluster_data.name} NAT Instance",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }

  tags = {
    "Name" = "${var.cluster_data.name} NAT Instance",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_eip" "nat" {
  count    = length(var.network_config.public_subnets)
  instance = aws_instance.nat.*.id[count.index]
  vpc      = true

  tags = {
    "Name" = "${var.cluster_data.name} NAT Elastic IP",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_route_table" "nat" {
  count  = length(var.network_config.private_subnets)
  vpc_id = var.network_data.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_data.name} NAT Table",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "shared"
  }
}

resource "aws_route" "nat" {
  count                  = length(var.network_config.private_subnets)
  route_table_id         = aws_route_table.nat.*.id[count.index]
  instance_id            = aws_instance.nat.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "nat" {
  count          = length(var.network_config.private_subnets)
  subnet_id      = var.network_data.private_subnet_ids[count.index]
  route_table_id = aws_route_table.nat.*.id[count.index]
}
