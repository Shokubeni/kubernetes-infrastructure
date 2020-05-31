output "control_plane_role_id" {
  value = aws_iam_role.control_plane.id

  depends_on = [
    aws_iam_role_policy_attachment.control_plane_cluster_policy,
    aws_iam_role_policy_attachment.control_plane_service_policy
  ]
}

output "control_plane_role_arn" {
  value = aws_iam_role.control_plane.arn

  depends_on = [
    aws_iam_role_policy_attachment.control_plane_cluster_policy,
    aws_iam_role_policy_attachment.control_plane_service_policy
  ]
}

output "worker_node_role_id" {
  value = aws_iam_role.worker_node.id

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.worker_ecr_policy,
    aws_iam_role_policy_attachment.worker_cni_policy
  ]
}

output "worker_node_role_arn" {
  value = aws_iam_role.worker_node.arn

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.worker_ecr_policy,
    aws_iam_role_policy_attachment.worker_cni_policy
  ]
}