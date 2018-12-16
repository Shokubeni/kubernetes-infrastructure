provider "aws" {
  access_key = "${var.provider_info["access_key"]}"
  secret_key = "${var.provider_info["secret_key"]}"
  region     = "${var.provider_info["region"]}"
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