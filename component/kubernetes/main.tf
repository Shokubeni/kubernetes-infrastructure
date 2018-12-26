terraform {
  backend "s3" {}
}

provider "aws" {
  profile = "${var.provider_info["profile"]}"
  region  = "${var.provider_info["region"]}"
}

module "network" {
  source = "./module/network"

  virtual_cloud_cidr = "${var.virtual_cloud_cidr}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  cluster_info       = "${var.cluster_info}"
}

module "security" {
  source = "./module/security"

  cluster_info = "${var.cluster_info}"
  vpc_id       = "${module.network.vpc_id}"
}