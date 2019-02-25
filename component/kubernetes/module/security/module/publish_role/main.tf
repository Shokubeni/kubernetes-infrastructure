data "template_file" "publish" {
  template = "${file("${path.module}/publish-policy.json")}"

  vars {
    worker_queue = "${var.cluster_config["label"]}-worker-lifecycle_${var.cluster_id}"
    master_queue = "${var.cluster_config["label"]}-master-lifecycle_${var.cluster_id}"
  }
}

resource "aws_iam_role" "publish" {
  name               = "${var.cluster_config["name"]}LifecyclePublish_${var.cluster_id}"
  description        = "Enables ASG to publish lifecycle hook events into SQS"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "publish" {
  name   = "LifecyclePublishInlinePolicy"
  role   = "${aws_iam_role.publish.id}"
  policy = "${data.template_file.publish.rendered}"
}