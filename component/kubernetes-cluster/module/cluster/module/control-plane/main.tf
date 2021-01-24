resource "aws_eks_cluster" "control_plane" {
  name                      = "${var.cluster_data.label}_${var.cluster_data.id}"
  version                   = var.runtime_config.k8s_version
  role_arn                  = var.control_plane.role_arn

  vpc_config {
    subnet_ids = var.network_data.private_subnet_ids
    security_group_ids = [
      var.control_plane.group_id
    ]
  }
}
