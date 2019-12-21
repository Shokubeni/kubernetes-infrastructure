locals {
  private_subnets_count = length(keys(var.network_config.private_subnets))
  private_subnets       = var.network_data.private_subnet_ids
  public_subnets_count  = length(keys(var.network_config.public_subnets))
  public_subnets        = var.network_data.public_subnet_ids
}

locals {
  zone_image = {
    us-east-1      = "ami-02cb555e324696ced"
    us-east-2      = "ami-065f49cc83d4ac233"
    us-west-1      = "ami-0a5bc72952095303e"
    us-west-2      = "ami-09483cf77526094c6"
    ca-central-1   = "ami-0b7ed25302d2f3ccb"
    eu-central-1   = "ami-001b36cbc16911c13"
    eu-west-1      = "ami-0ab9a54c72bfd7a10"
    eu-west-2      = "ami-05474bc96b000c7eb"
    eu-west-3      = "ami-037c41b569f02dc0c"
    eu-north-1     = "ami-5118932f"
    ap-east-1      = "ami-c3e893b2"
    ap-south-1     = "ami-08f97681b0eee9570"
    ap-northeast-2 = "ami-0704a255aaf5a4f73"
    ap-southeast-1 = "ami-0012a981fe3b8891f"
    ap-southeast-2 = "ami-01866304647fb36d8"
    ap-northeast-1 = "ami-0589b7f94831e06c1"
    sa-east-1      = "ami-03d017c94126c69f7"
    me-south-1     = "ami-06b8cb788b8659523"
  }
}

resource "aws_network_interface" "nat" {
  count             = local.public_subnets_count
  subnet_id         = local.public_subnets[count.index]
  security_groups   = [var.nat_node_security.group_id]
  source_dest_check = "false"

  tags = {
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_instance" "nat" {
  count                                = local.public_subnets_count
  ami                                  = local.zone_image[var.cluster_config.region]
  instance_type                        = var.network_config.nat_instance_type
  key_name                             = var.nat_node_security.key_id
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
    "Name" = "${var.cluster_config.name} NAT Instance",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }

  tags = {
    "Name" = "${var.cluster_config.name} NAT Instance",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_eip" "nat" {
  count    = local.public_subnets_count
  instance = aws_instance.nat.*.id[count.index]
  vpc      = true

  tags = {
    "Name" = "${var.cluster_config.name} NAT Elastic IP",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_route_table" "nat" {
  count  = local.private_subnets_count
  vpc_id = var.network_data.virtual_cloud_id

  tags = {
    "Name" = "${var.cluster_config.name} NAT Table",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_route" "nat" {
  count                  = local.private_subnets_count
  route_table_id         = aws_route_table.nat.*.id[count.index]
  instance_id            = aws_instance.nat.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "nat" {
  count          = local.private_subnets_count
  subnet_id      = local.private_subnets[count.index]
  route_table_id = aws_route_table.nat.*.id[count.index]
}
