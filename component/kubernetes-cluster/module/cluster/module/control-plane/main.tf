resource "aws_cloudwatch_log_group" "control_plane" {
  name              = "/aws/eks/${var.cluster_data.label}_${var.cluster_data.id}/cluster"
  retention_in_days = var.runtime_config.logs.retention

  tags = {
    "Name" = "${var.cluster_data.name} Cloudwatch Group"
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "owned"
  }
}

resource "aws_eks_cluster" "control_plane" {
  name                      = "${var.cluster_data.label}_${var.cluster_data.id}"
  version                   = var.runtime_config.k8s_version
  role_arn                  = var.control_plane.role_arn
  enabled_cluster_log_types = var.runtime_config.logs.types

  vpc_config {
    subnet_ids = var.network_data.private_subnet_ids
    security_group_ids = [
      var.control_plane.group_id
    ]
  }

  depends_on = [
    aws_cloudwatch_log_group.control_plane
  ]
}
