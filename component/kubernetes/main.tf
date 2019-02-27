terraform {
  backend "s3" {}
}

provider "aws" {
  profile = "${var.provider_config["profile"]}"
  region  = "${var.provider_config["region"]}"
  version = ">= 1.50.0"
}

module "common" {
  source = "./module/common"

  cluster_config     = "${var.cluster_config}"
}

module "network" {
  source = "./module/network"

  virtual_cloud_cidr = "${var.virtual_cloud_cidr}"
  use_nat_gateways   = "${var.use_nat_gateways}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${module.common.cluster_id}"
}

module "security" {
  source = "./module/security"

  virtual_cloud_id   = "${module.network.virtual_cloud_id}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${module.common.cluster_id}"
}

module "balancer" {
  source = "./module/balancer"

  public_subnet_ids  = "${module.network.public_subnet_ids}"
  security_group_id  = "${module.security.balancer_security_group_id}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${module.common.cluster_id}"
}

module "master" {
  source = "./module/compute"

  cluster_role       = ["controlplane"]
  private_subnet_ids = "${module.network.private_subnet_ids}"
  load_balancer_dns  = "${module.balancer.balancer_dns}"
  load_balancer_id   = "${module.balancer.balancer_id}"
  secure_bucket_name = "${module.common.bucket_id}"
  security_group_id  = "${module.security.master_security_group_id}"
  publish_role_arn   = "${module.security.publish_iam_role_arn}"
  lambda_role_arn    = "${module.security.lambda_iam_role_arn}"
  node_role_id       = "${module.security.master_iam_role_id}"
  key_pair_id        = "${module.security.master_key_id}"
  system_comands     = "${module.common.system_commands}"
  launch_config      = "${var.master_launch_config}"
  volume_config      = "${var.master_volume_config}"
  is_public_ip       = "${!var.use_nat_gateways}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${module.common.cluster_id}"
}

module "worker" {
  source = "./module/compute"

  cluster_role       = ["worker"]
  private_subnet_ids = "${module.network.private_subnet_ids}"
  secure_bucket_name = "${module.common.bucket_id}"
  security_group_id  = "${module.security.worker_security_group_id}"
  publish_role_arn   = "${module.security.publish_iam_role_arn}"
  lambda_role_arn    = "${module.security.lambda_iam_role_arn}"
  node_role_id       = "${module.security.worker_iam_role_id}"
  key_pair_id        = "${module.security.worker_key_id}"
  system_comands     = "${module.common.system_commands}"
  launch_config      = "${var.worker_launch_config}"
  volume_config      = "${var.worker_volume_config}"
  is_public_ip       = "${!var.use_nat_gateways}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${module.common.cluster_id}"
}

module "outputs" {
  source = "./module/outputs"

  secure_bucket_name = "${module.common.bucket_id}"
  root_dir           = "${var.root_dir}"
  dependencies       = [
    "${module.master.autoscaling_group_id}",
    "${module.worker.autoscaling_group_id}"
  ]
}