output "ebs_storage" {
  value = {
    namespace = helm_release.ebs_storage.namespace
    version   = helm_release.ebs_storage.version
    name      = helm_release.ebs_storage.name
  }

  depends_on = [
    helm_release.ebs_storage
  ]
}