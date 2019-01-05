resource "aws_iam_role" "autoscale" {
  name               = "${var.cluster_config["name"]}Autoscaling@${var.cluster_id}"
  description        = "Enables resource access for autoscaling groups"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "autoscale" {
  name   = "NodesAutoscalingInlinePolicy"
  role   = "${aws_iam_role.autoscale.id}"
  policy = "${file("${path.module}/scaling-policy.json")}"
}