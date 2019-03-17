resource "aws_sqs_queue" "master_lifecycle" {
  name                       = "${var.cluster_config["label"]}-master-lifecycle_${var.cluster_id}"
  message_retention_seconds  = 600
  visibility_timeout_seconds = 600

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Master Lifecycle",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_sqs_queue" "worker_lifecycle" {
  name                       = "${var.cluster_config["label"]}-worker-lifecycle_${var.cluster_id}"
  message_retention_seconds  = 600
  visibility_timeout_seconds = 600

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Worker Lifecycle",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}