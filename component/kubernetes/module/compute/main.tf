module "launch_tempate" {
  source = "./module/launch_template"

  cluster_role         = "${var.cluster_role}"
  private_subnet_ids   = "${split(",", var.network_data["private_subnet_ids"])}"
  security_group_id    = "${var.node_security["group_id"]}"
  node_role_id         = "${var.node_security["role_id"]}"
  key_pair_id          = "${var.node_security["key_id"]}"
  launch_config        = "${var.launch_config}"
  volume_config        = "${var.volume_config}"
  cluster_config       = "${var.cluster_config}"
  is_public_ip         = "${var.is_public_ip}"
}

module "autoscaling_group" {
  source = "./module/autoscaling_group"

  cluster_role         = "${var.cluster_role}"
  private_subnet_ids   = "${split(",", var.network_data["private_subnet_ids"])}"
  launch_template_id   = "${module.launch_tempate.template_id}"
  load_balancer_id     = "${var.balancer_data["id"]}"
  publish_queue_arn    = "${var.lifecycle_queue["arn"]}"
  publish_role_arn     = "${var.publish_role["arn"]}"
  cluster_config       = "${var.cluster_config}"
  launch_config        = "${var.launch_config}"
  function_name        = "${var.lifecycle_function["id"]}"
}