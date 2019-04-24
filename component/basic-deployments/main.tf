terraform {
  backend "s3" {}
}

data "terraform_remote_state" "kubernetes" {
  backend = "s3"

  config {
    key    = "kubernetes-cluster/terraform.tfstate"
    bucket = "${var.backend_bucket}"
    region = "${var.backend_region}"
  }
}

provider "aws" {
  profile = "${var.provider_profile}"
  region  = "${var.provider_region}"
  version = ">= 1.50.0"
}

locals {
  cluster_config = "${data.terraform_remote_state.kubernetes.cluster_config}"
  balancer_data  = "${data.terraform_remote_state.kubernetes.balancer_data}"
  network_data   = "${data.terraform_remote_state.kubernetes.network_data}"
  config_path    = "${data.terraform_remote_state.kubernetes.config_path}"
}

module "dns_config" {
  source = "./module/dns-configuration"

  balancer_data    = "${local.balancer_data}"
  provider_profile = "${var.provider_profile}"
  provider_region  = "${var.provider_region}"
  domain_config    = "${var.domain_config}"
  is_main_cluster  = "${var.is_main_cluster}"
}

module "efs" {
  source = "./module/efs-provisioner"

  virtual_cloud_cidr = "${var.virtual_cloud_cidr}"
  cluster_config     = "${local.cluster_config}"
  domain_config      = "${var.domain_config}"
  network_data       = "${local.network_data}"
  config_path        = "${local.config_path}"
}

module "workloads" {
  source = "./module/workload-config"

  config_path = "${local.config_path}"
}