output "velero" {
  value = {
    namespace = helm_release.velero.namespace
    version   = helm_release.velero.version
    name      = helm_release.velero.name
  }

  depends_on = [
    helm_release.velero
  ]
}