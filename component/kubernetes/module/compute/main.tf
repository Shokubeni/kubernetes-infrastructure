locals {
  private_subnets_zones = "${values(var.private_subnets)}"
  private_subnets_cidrs = "${keys(var.private_subnets)}"
  public_subnets_zones  = "${values(var.public_subnets)}"
  public_subnets_cidrs  = "${keys(var.public_subnets)}"
}

module "master_tempate" {
  source = "./module/launch_template"

  security_group_id = "${var.master_security_group_id}"
  iam_role_id       = "${var.master_iam_role_id}"
  node_instance     = "${var.master_launch_config}"
  root_volume       = "${var.master_volume_config}"
  key_name          = "${var.master_key_name}"
  subnets_cidrs     = "${local.private_subnets_cidrs}"
  subnets_zones     = "${local.private_subnets_zones}"
  subnets_ids       = "${var.private_subnets_ids}"
  cluster_config    = "${var.cluster_config}"
  template_postfix  = "master"
}

module "master_group" {
  source = "./module/autoscaling_group"

  autoscaling_id  = "${var.autoscaling_iam_role_id}"
  groups_count    = "${length(local.private_subnets_cidrs)}"
  templates_ids   = "${module.master_tempate.templates_ids}"
  node_instance   = "${var.master_launch_config}"
  cluster_config  = "${var.cluster_config}"
  group_postfix   = "master"
}

module "worker_tempate" {
  source = "./module/launch_template"

  security_group_id = "${var.worker_security_group_id}"
  iam_role_id       = "${var.worker_iam_role_id}"
  node_instance     = "${var.worker_launch_config}"
  root_volume       = "${var.worker_volume_config}"
  key_name          = "${var.worker_key_name}"
  subnets_cidrs     = "${local.private_subnets_cidrs}"
  subnets_zones     = "${local.private_subnets_zones}"
  subnets_ids       = "${var.private_subnets_ids}"
  cluster_config    = "${var.cluster_config}"
  template_postfix  = "worker"
}

module "worker_group" {
  source = "./module/autoscaling_group"

  autoscaling_id  = "${var.autoscaling_iam_role_id}"
  groups_count    = "${length(local.private_subnets_cidrs)}"
  templates_ids   = "${module.worker_tempate.templates_ids}"
  node_instance   = "${var.worker_launch_config}"
  cluster_config  = "${var.cluster_config}"
  group_postfix   = "worker"
}