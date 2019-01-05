resource "aws_autoscaling_group" "default" {
  count    = "${var.groups_count}"
  name     = "${var.cluster_config["label"]}-${var.group_postfix}-${substr(sha512(timestamp()), 0, 5)}"
  max_size = "${var.node_instance["max_size"]}"
  min_size = "${var.node_instance["min_size"]}"

  launch_template = {
    id      = "${element(var.templates_ids, count.index)}"
    version = "$Latest"
  }
}