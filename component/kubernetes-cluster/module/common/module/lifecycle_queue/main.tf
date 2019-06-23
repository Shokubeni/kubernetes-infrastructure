resource "aws_sqs_queue" "master_lifecycle" {
  name                       = "${var.cluster_label}-master-lifecycle_${var.cluster_id}"
  message_retention_seconds  = 600
  visibility_timeout_seconds = 600

  tags = {
    "Name" = "${var.cluster_name} Master Lifecycle",
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}

resource "aws_sqs_queue" "worker_lifecycle" {
  name                       = "${var.cluster_label}-worker-lifecycle_${var.cluster_id}"
  message_retention_seconds  = 600
  visibility_timeout_seconds = 600

  tags = {
    "Name" = "${var.cluster_name} Worker Lifecycle",
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}