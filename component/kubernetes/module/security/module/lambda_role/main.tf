data "template_file" "lambda" {
  template = "${file("${path.module}/lambda-policy.json")}"

  vars {
    worker_queue = "${var.cluster_config["label"]}-worker-lifecycle_${var.cluster_id}"
    master_queue = "${var.cluster_config["label"]}-master-lifecycle_${var.cluster_id}"
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.cluster_config["name"]}LifecycleLambda_${var.cluster_id}"
  description        = "Enables lambda functions to handle ASG instance hooks"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "lambda" {
  name   = "LifecycleLambdaInlinePolicy"
  role   = "${aws_iam_role.lambda.id}"
  policy = "${data.template_file.lambda.rendered}"
}