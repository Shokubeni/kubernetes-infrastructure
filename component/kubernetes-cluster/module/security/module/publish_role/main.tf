data "template_file" "master_publish" {
  template = "${file("${path.module}/publish-policy.json")}"

  vars {
    account_id = "${var.cluster_config["account"]}"
    queue_name = "${var.master_queue}"
  }
}

resource "aws_iam_role" "master_publish" {
  name               = "${var.cluster_config["name"]}MasterPublish_${var.cluster_config["id"]}"
  description        = "Enables ASG to publish lifecycle hook events into SQS"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "master_publish" {
  name   = "LifecyclePublishInlinePolicy"
  role   = "${aws_iam_role.master_publish.id}"
  policy = "${data.template_file.master_publish.rendered}"
}

data "template_file" "worker_publish" {
  template = "${file("${path.module}/publish-policy.json")}"

  vars {
    account_id = "${var.cluster_config["account"]}"
    queue_name = "${var.worker_queue}"
  }
}

resource "aws_iam_role" "worker_publish" {
  name               = "${var.cluster_config["name"]}WorkerPublish_${var.cluster_config["id"]}"
  description        = "Enables ASG to publish lifecycle hook events into SQS"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "worker_publish" {
  name   = "LifecyclePublishInlinePolicy"
  role   = "${aws_iam_role.worker_publish.id}"
  policy = "${data.template_file.worker_publish.rendered}"
}