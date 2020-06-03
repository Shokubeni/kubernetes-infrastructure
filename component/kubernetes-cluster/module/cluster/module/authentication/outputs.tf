output "config_file" {
  value = local_file.kubeconfig.filename

  depends_on = [
    null_resource.wait_for_cluster
  ]
}

output "openid_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn

  depends_on = [
    null_resource.wait_for_cluster
  ]
}

output "openid_url" {
  value = aws_iam_openid_connect_provider.oidc_provider.url

  depends_on = [
    null_resource.wait_for_cluster
  ]
}