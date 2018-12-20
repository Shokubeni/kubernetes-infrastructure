provider "aws" {
  access_key = "${var.provider_info["access_key"]}"
  secret_key = "${var.provider_info["secret_key"]}"
  region     = "${var.provider_info["region"]}"
}

resource "null_resource" "cluster_dir_creator" {
  provisioner "local-exec" {
    command = "rm -rf cluster || true && mkdir cluster"
  }
}

module "network" {
  source = "./module/network"

  virtual_cloud_cidr = "${var.virtual_cloud_cidr}"
  private_subnets = "${var.private_subnets}"
  public_subnets = "${var.public_subnets}"
  cluster_info = {
    label = "${var.cluster_info["label"]}"
    name  = "${var.cluster_info["name"]}"
  }
}

module "security" {
  source = "./module/security"

  vpc_id = "${module.network.vpc_id}"
  cluster_info = {
    label = "${var.cluster_info["label"]}"
    name  = "${var.cluster_info["name"]}"
  }
}