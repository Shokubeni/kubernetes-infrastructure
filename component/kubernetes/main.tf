terraform {
  backend "s3" {}
}

provider "aws" {
  profile = "${var.provider_config["profile"]}"
  region  = "${var.provider_config["region"]}"
}

module "network" {
  source = "./module/network"

  virtual_cloud_cidr = "${var.virtual_cloud_cidr}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  cluster_config     = "${var.cluster_config}"
}

module "security" {
  source = "./module/security"

  virtual_cloud_id = "${module.network.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
}

module "compute" {
  source = "./module/compute"

  master_security_group_id = "${module.security.master_security_group_id}"
  master_iam_role_id       = "${module.security.master_iam_role_id}"
  master_key_name          = "${module.security.master_key_name}"
  master_node_instance     = "${var.master_node_instance}"
  master_root_volume       = "${var.master_root_volume}"

  worker_security_group_id = "${module.security.worker_security_group_id}"
  worker_iam_role_id       = "${module.security.worker_iam_role_id}"
  worker_key_name          = "${module.security.worker_key_name}"
  worker_node_instance     = "${var.worker_node_instance}"
  worker_root_volume       = "${var.worker_root_volume}"

  private_subnets_ids      = "${module.network.private_subnets_ids}"
  private_subnets          = "${var.private_subnets}"
  public_subnets_ids       = "${module.network.public_subnets_ids}"
  public_subnets           = "${var.public_subnets}"
  virtual_cloud_id         = "${module.network.virtual_cloud_id}"
  cluster_config           = "${var.cluster_config}"
}