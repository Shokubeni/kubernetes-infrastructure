module "autoscaling_hook" {
  source = "./module/autoscaling_hook"

  cluster_role       = "${var.cluster_role}"
  secure_bucket_name = "${var.secure_bucket_name}"
  load_balancer_dns  = "${var.load_balancer_dns}"
  lambda_role_arn    = "${var.lambda_role_arn}"
  system_comands     = "${var.system_comands}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${var.cluster_id}"
}

module "launch_tempate" {
  source = "./module/launch_template"

  cluster_role       = "${var.cluster_role}"
  security_group_id  = "${var.security_group_id}"
  node_role_id       = "${var.node_role_id}"
  key_pair_id        = "${var.key_pair_id}"
  launch_config      = "${var.launch_config}"
  volume_config      = "${var.volume_config}"
  subnet_ids         = "${var.private_subnet_ids}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${var.cluster_id}"
  is_public_ip       = "${var.is_public_ip}"
}

module "autoscaling_group" {
  source = "./module/autoscaling_group"

  cluster_role       = "${var.cluster_role}"
  launch_config      = "${var.launch_config}"
  load_balancer_id   = "${var.load_balancer_id}"
  subnet_ids         = "${var.private_subnet_ids}"
  publish_queue_arn  = "${module.autoscaling_hook.queue_arn}"
  publish_role_arn   = "${var.publish_role_arn}"
  template_id        = "${module.launch_tempate.template_id}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${var.cluster_id}"
}

module "cloudwatch_event" {
  source = "./module/cloudwatch_event"

  cluster_role       = "${var.cluster_role}"
  secure_bucket_name = "${var.secure_bucket_name}"
  lambda_role_arn    = "${var.lambda_role_arn}"
  system_comands     = "${var.system_comands}"
  cluster_config     = "${var.cluster_config}"
  cluster_id         = "${var.cluster_id}"
}