module "launch_tempate" {
  source = "./module/launch_template"

  cluster_role      = "${var.cluster_role}"
  security_group_id = "${var.security_group_id}"
  node_role_id      = "${var.node_role_id}"
  key_pair_id       = "${var.key_pair_id}"
  launch_config     = "${var.launch_config}"
  volume_config     = "${var.volume_config}"
  subnet_count      = "${length(keys(var.private_subnets))}"
  subnet_ids        = "${var.private_subnet_ids}"
  cluster_config    = "${var.cluster_config}"
  cluster_id        = "${var.cluster_id}"
}

//module "autoscaling_group" {
//  source = "./module/autoscaling_group"
//
//  autoscaling_id  = "${var.autoscaling_iam_role_id}"
//  groups_count    = "${length(local.private_subnets_cidrs)}"
//  templates_ids   = "${module.master_tempate.templates_ids}"
//  node_instance   = "${var.master_launch_config}"
//  cluster_config  = "${var.cluster_config}"
//  group_postfix   = "master"
//}