locals {
  private_subnets_count = "${length(keys(var.private_subnets))}"
  private_subnets       = "${split(",", var.network_data["private_subnet_ids"])}"
  public_subnets_count  = "${length(keys(var.public_subnets))}"
  public_subnets        = "${split(",", var.network_data["public_subnet_ids"])}"
}

locals {
  zone_image = {
    us-east-1      = "ami-00a9d4a05375b2763"
    us-east-2      = "ami-00d1f8201864cc10c"
    us-west-1      = "ami-097ad469381034fa2"
    us-west-2      = "ami-0553ff0c22b782b45"
    ca-central-1   = "ami-082d247275fbe5c20"
    eu-central-1   = "ami-06465d49ba60cf770"
    eu-west-1      = "ami-0236d0cbbbe64730c"
    eu-west-2      = "ami-029dbaca987ff4afe"
    eu-west-3      = "ami-0050bb60cea70c5b3"
    eu-north-1     = "ami-28d15f56"
    ap-northeast-1 = "ami-00d29e4cb217ae06b"
    ap-northeast-2 = "ami-07e3822d44637d67c"
    ap-southeast-1 = "ami-01514bb1776d5c018"
    ap-southeast-2 = "ami-00c1445796bc0a29f"
    ap-south-1     = "ami-00b3aa8a93dd09c13"
    sa-east-1      = "ami-057f5d52ff7ae75ae"
  }
}

resource "aws_network_interface" "nat" {
  count             = "${local.public_subnets_count}"
  subnet_id         = "${element(local.public_subnets, count.index)}"
  security_groups   = ["${var.nat_security["group_id"]}"]
  source_dest_check = "false"

  tags = "${merge(
    map(
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_instance" "nat" {
  count                                = "${local.public_subnets_count}"
  ami                                  = "${local.zone_image[var.cluster_config["region"]]}"
  instance_type                        = "${var.nat_instance_type}"
  key_name                             = "${var.nat_security["key_id"]}"
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
    network_interface_id = "${element(aws_network_interface.nat.*.id, count.index)}"
    device_index         = 0
  }

  volume_tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} NAT Instance",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} NAT Instance",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_eip" "nat" {
  count    = "${local.public_subnets_count}"
  instance = "${element(aws_instance.nat.*.id, count.index)}"
  vpc      = true

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} NAT Elastic IP",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_route_table" "nat" {
  count  = "${local.private_subnets_count}"
  vpc_id = "${var.network_data["virtual_cloud_id"]}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} NAT Table",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_route" "nat" {
  count                  = "${local.private_subnets_count}"
  route_table_id         = "${element(aws_route_table.nat.*.id, count.index)}"
  instance_id            = "${element(aws_instance.nat.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "nat" {
  count          = "${local.private_subnets_count}"
  subnet_id      = "${element(local.private_subnets, count.index)}"
  route_table_id = "${element(aws_route_table.nat.*.id, count.index)}"
}