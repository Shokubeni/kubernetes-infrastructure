module "launch_tempate" {
  source = "./module/launch_template"

  cluster_role      = "${var.cluster_role}"
  security_group_id = "${var.security_group_id}"
  node_role_id      = "${var.node_role_id}"
  key_pair_id       = "${var.key_pair_id}"
  launch_config     = "${var.launch_config}"
  volume_config     = "${var.volume_config}"
  subnet_ids        = "${var.private_subnet_ids}"
  cluster_config    = "${var.cluster_config}"
  cluster_id        = "${var.cluster_id}"
}

module "autoscaling_group" {
  source = "./module/autoscaling_group"

  cluster_role      = "${var.cluster_role}"
  launch_config     = "${var.launch_config}"
  subnet_ids        = "${var.private_subnet_ids}"
  template_id       = "${module.launch_tempate.template_id}"
  cluster_config    = "${var.cluster_config}"
  cluster_id        = "${var.cluster_id}"
}