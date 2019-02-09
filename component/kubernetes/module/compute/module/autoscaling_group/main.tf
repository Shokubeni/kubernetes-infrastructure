locals {
  desired_capacity = "${lookup(var.launch_config, "desired_capacity", 1)}"
  max_size         = "${lookup(var.launch_config, "max_size", 1)}"
  min_size         = "${lookup(var.launch_config, "min_size", 1)}"
  check_type       = "${
    contains(var.cluster_role, "controlplane")
        ? "ELB"
        : "EC2"
  }"
  role_postfix     = "${
    contains(var.cluster_role, "controlplane")
        ? "master"
        : "worker"
  }"
  role_name        = "${
    contains(var.cluster_role, "controlplane")
        ? "Master"
        : "Worker"
  }"
}

resource "aws_autoscaling_group" "autoscaling" {
  name                      = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
  desired_capacity          = "${local.desired_capacity}"
  max_size                  = "${local.max_size}"
  min_size                  = "${local.min_size}"
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  health_check_type         = "${local.check_type}"
  force_delete              = false

  initial_lifecycle_hook {
    name                    = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
    default_result          = "ABANDON"
    heartbeat_timeout       = 300
    lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
    notification_target_arn = "${var.publish_queue_arn}"
    role_arn                = "${var.publish_role_arn}"
  }

  launch_template = {
    id      = "${var.template_id}"
    version = "$Latest"
  }
}