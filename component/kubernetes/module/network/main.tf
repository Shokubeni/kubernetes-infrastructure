locals {
  private_subnets_zones = "${values(var.private_subnets)}"
  private_subnets_cidrs = "${keys(var.private_subnets)}"
  public_subnets_zones  = "${values(var.public_subnets)}"
  public_subnets_cidrs  = "${keys(var.public_subnets)}"
}

module "virtual_cloud" {
  source = "./module/virtual_cloud"

  virtual_cloud_cidr = "${var.virtual_cloud_cidr}"
  cluster_config     = "${var.cluster_config}"
}

module "private_subnets" {
  source = "./module/private_subnets"

  virtual_cloud_id = "${module.virtual_cloud.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
  subnets_zones    = "${local.private_subnets_zones}"
  subnets_cidrs    = "${local.private_subnets_cidrs}"
}

module "public_subnets" {
  source = "./module/public_subnets"

  virtual_cloud_id = "${module.virtual_cloud.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
  subnets_zones    = "${local.public_subnets_zones}"
  subnets_cidrs    = "${local.public_subnets_cidrs}"
}

module "internet_gateway" {
  source = "./module/internet_gateway"

  virtual_cloud_id = "${module.virtual_cloud.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
  subnets_count    = "${length(local.public_subnets_cidrs)}"
  subnets_ids      = "${module.public_subnets.subnets_ids}"

}

module "nat_gateway" {
  source = "./module/nat_gateway"

  virtual_cloud_id = "${module.virtual_cloud.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
  subnets_count    = "${length(local.private_subnets_cidrs)}"
  subnets_ids      = "${module.private_subnets.subnets_ids}"
}