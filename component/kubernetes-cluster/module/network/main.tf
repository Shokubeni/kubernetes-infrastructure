locals {
  private_subnets_zones = "${values(var.private_subnets)}"
  private_subnets_cidrs = "${keys(var.private_subnets)}"
  public_subnets_zones  = "${values(var.public_subnets)}"
  public_subnets_cidrs  = "${keys(var.public_subnets)}"
}

module "virtual_cloud" {
  source = "./module/virtual_cloud"

  virtual_cloud_cidr    = "${var.virtual_cloud_cidr}"
  cluster_config        = "${var.cluster_config}"
}

module "private_subnet" {
  source = "./module/private_subnet"

  virtual_cloud_id      = "${module.virtual_cloud.cloud_id}"
  subnets_count         = "${length(local.private_subnets_cidrs)}"
  subnets_zones         = "${local.private_subnets_zones}"
  subnets_cidrs         = "${local.private_subnets_cidrs}"
  cluster_config        = "${var.cluster_config}"
}

module "public_subnet" {
  source = "./module/public_subnet"

  virtual_cloud_id      = "${module.virtual_cloud.cloud_id}"
  subnets_count         = "${length(local.public_subnets_cidrs)}"
  subnets_zones         = "${local.public_subnets_zones}"
  subnets_cidrs         = "${local.public_subnets_cidrs}"
  cluster_config        = "${var.cluster_config}"
}

module "internet_gateway" {
  source = "./module/internet_gateway"

  use_nat_gateways      = "${var.use_nat_gateways}"
  virtual_cloud_id      = "${module.virtual_cloud.cloud_id}"
  public_subnets_count  = "${length(local.public_subnets_cidrs)}"
  public_subnets_ids    = "${module.public_subnet.subnet_ids}"
  private_subnets_count = "${length(local.private_subnets_cidrs)}"
  private_subnets_ids   = "${module.private_subnet.subnet_ids}"
  cluster_config        = "${var.cluster_config}"
}

module "nat_gateway" {
  source = "./module/nat_gateway"

  use_nat_gateways      = "${var.use_nat_gateways}"
  virtual_cloud_id      = "${module.virtual_cloud.cloud_id}"
  public_subnets_count  = "${length(local.public_subnets_cidrs)}"
  public_subnets_ids    = "${module.public_subnet.subnet_ids}"
  private_subnets_count = "${length(local.private_subnets_cidrs)}"
  private_subnets_ids   = "${module.private_subnet.subnet_ids}"
  cluster_config        = "${var.cluster_config}"
}