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

//module "compute" {
//  source = "./module/compute"
//
//  security_group_id = "${module.security.master_security_group_id}"
//  master_iam_role_id       = "${module.security.master_iam_role_id}"
//  master_key_name          = "${module.security.master_key_name}"
//  master_launch_config     = "${var.master_launch_config}"
//  master_volume_config       = "${var.master_volume_config}"
//
//  worker_security_group_id = "${module.security.worker_security_group_id}"
//  worker_iam_role_id       = "${module.security.worker_iam_role_id}"
//  worker_key_name          = "${module.security.worker_key_name}"
//  worker_launch_config     = "${var.worker_launch_config}"
//  worker_volume_config       = "${var.worker_volume_config}"
//
//  autoscaling_iam_role_id  = "${module.security.autoscaling_iam_role_id}"
//  private_subnets_ids      = "${module.network.private_subnets_ids}"
//  private_subnets          = "${var.private_subnets}"
//  public_subnets_ids       = "${module.network.public_subnets_ids}"
//  public_subnets           = "${var.public_subnets}"
//  virtual_cloud_id         = "${module.network.virtual_cloud_id}"
//  cluster_config           = "${var.cluster_config}"
//}