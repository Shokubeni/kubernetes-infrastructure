resource "aws_iam_role" "master" {
  name               = "${var.cluster_info["name"]}MasterNode"
  description        = "Enables resource access for cluster master node"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role" "worker" {
  name               = "${var.cluster_info["name"]}WorkerNode"
  description        = "Enables resource access for cluster worker node"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "master" {
  name   = "MasterNodeInlinePolicy"
  role   = "${aws_iam_role.master.id}"
  policy = "${file("${path.module}/master-policy.json")}"
}

resource "aws_iam_role_policy" "worker" {
  name   = "WorkerNodeInlinePolicy"
  role   = "${aws_iam_role.worker.id}"
  policy = "${file("${path.module}/worker-policy.json")}"
}