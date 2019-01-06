terraform {
  backend "s3" {}
}

provider "aws" {
  profile = "${var.provider_config["profile"]}"
  region  = "${var.provider_config["region"]}"
  version = ">= 1.50.0"
}

resource "random_id" "cluster" {
  byte_length = 8
}

module "network" {
  source = "./module/network"

  virtual_cloud_cidr = "${var.virtual_cloud_cidr}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${random_id.cluster.hex}"
}

module "security" {
  source = "./module/security"

  virtual_cloud_id   = "${module.network.virtual_cloud_id}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${random_id.cluster.hex}"
}

module "master" {
  source = "./module/compute"

  cluster_role       = ["controlplane"]
  private_subnet_ids = "${module.network.private_subnet_ids}"
  private_subnets    = "${var.private_subnets}"
  security_group_id  = "${module.security.master_security_group_id}"
  autoscale_role_id  = "${module.security.autoscaling_iam_role_id}"
  node_role_id       = "${module.security.master_iam_role_id}"
  key_pair_id        = "${module.security.master_key_id}"
  launch_config      = "${var.master_launch_config}"
  volume_config      = "${var.master_volume_config}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${random_id.cluster.hex}"
}