output "control_plane_authority" {
  value = aws_eks_cluster.control_plane.certificate_authority[0].data

  depends_on = [
    aws_eks_cluster.control_plane,
  ]
}

output "control_plane_endpoint" {
  value = aws_eks_cluster.control_plane.endpoint

  depends_on = [
    aws_eks_cluster.control_plane
  ]
}

output "control_plane_issuer" {
  value = aws_eks_cluster.control_plane.identity.0.oidc.0.issuer

  depends_on = [
    aws_eks_cluster.control_plane
  ]
}

output "control_plane_id" {
  value = aws_eks_cluster.control_plane.id

  depends_on = [
    aws_eks_cluster.control_plane
  ]
}