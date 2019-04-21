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

locals {
  balancer_zone = "${data.terraform_remote_state.kubernetes.balancer_zone}"
  balancer_dns  = "${data.terraform_remote_state.kubernetes.balancer_dns}"
  config_path   = "${data.terraform_remote_state.kubernetes.config_path}"
}

module "dns_config" {
  source = "./module/dns-configuration"

  balancer_zone    = "${local.balancer_zone}"
  balancer_dns     = "${local.balancer_dns}"
  provider_profile = "${var.provider_profile}"
  provider_region  = "${var.provider_region}"
  domain_config    = "${var.domain_config}"
  is_main_cluster  = "${var.is_main_cluster}"
}

module "workloads" {
  source = "./module/workload-config"

  config_path = "${local.config_path}"
}