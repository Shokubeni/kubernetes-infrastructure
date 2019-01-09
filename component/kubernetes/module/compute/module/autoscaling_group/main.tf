locals {
  desired_capacity = "${lookup(var.launch_config, "desired_capacity", 1)}"
  max_size         = "${lookup(var.launch_config, "max_size", 1)}"
  min_size         = "${lookup(var.launch_config, "min_size", 1)}"
  role_postfix     = "${
    contains(var.cluster_role, "controlplane")
        ? "master"
        : "worker"
  }"
}

resource "aws_autoscaling_group" "autoscaling" {
  name                      = "${var.cluster_config["label"]}-${local.role_postfix}.${var.cluster_id}"
  desired_capacity          = "${local.desired_capacity}"
  max_size                  = "${local.max_size}"
  min_size                  = "${local.min_size}"
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  force_delete              = false

  launch_template = {
    id      = "${var.template_id}"
    version = "$Latest"
  }
}