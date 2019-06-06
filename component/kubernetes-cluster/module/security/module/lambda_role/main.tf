data "template_file" "master_lifecycle" {
  template = "${file("${path.module}/lifecycle-policy.json")}"

  vars {
    account_id     = "${var.cluster_config["account"]}"
    cluster_id     = "${var.cluster_config["id"]}"
    backup_bucket  = "${var.backup_bucket}"
    cluster_bucket = "${var.bucket_name}"
    group_name     = "${var.cluster_config["label"]}-master_${var.cluster_config["id"]}"
    queue_name     = "${var.master_queue}"
  }
}

resource "aws_iam_role" "master_lifecycle" {
  name               = "${var.cluster_config["name"]}MasterLifecycle_${var.cluster_config["id"]}"
  description        = "Enables lambda functions to handle ASG lifecycle hooks"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "master_lifecycle" {
  name   = "LifecycleLambdaInlinePolicy"
  role   = "${aws_iam_role.master_lifecycle.id}"
  policy = "${data.template_file.master_lifecycle.rendered}"
}

data "template_file" "worker_lifecycle" {
  template = "${file("${path.module}/lifecycle-policy.json")}"

  vars {
    account_id     = "${var.cluster_config["account"]}"
    cluster_id     = "${var.cluster_config["id"]}"
    backup_bucket  = "${var.backup_bucket}"
    cluster_bucket = "${var.bucket_name}"
    queue_name     = "${var.worker_queue}"
  }
}

resource "aws_iam_role" "worker_lifecycle" {
  name               = "${var.cluster_config["name"]}WorkerLifecycle_${var.cluster_config["id"]}"
  description        = "Enables lambda functions to handle ASG lifecycle hooks"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "worker_lifecycle" {
  name   = "LifecycleLambdaInlinePolicy"
  role   = "${aws_iam_role.worker_lifecycle.id}"
  policy = "${data.template_file.worker_lifecycle.rendered}"
}

data "template_file" "cloudwatch_event" {
  template = "${file("${path.module}/cloudwatch-policy.json")}"
}

resource "aws_iam_role" "cloudwatch_event" {
  name               = "${var.cluster_config["name"]}CloudwatchEvent_${var.cluster_config["id"]}"
  description        = "Enables lambda functions to handle Cloudwatch events"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "cloudwatch_event" {
  name   = "CloudwatchLambdaInlinePolicy"
  role   = "${aws_iam_role.cloudwatch_event.id}"
  policy = "${data.template_file.cloudwatch_event.rendered}"
}