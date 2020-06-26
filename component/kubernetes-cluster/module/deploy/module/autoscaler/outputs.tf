output "autoscaler" {
  value = {
    namespace = helm_release.autoscaler.namespace
    version   = helm_release.autoscaler.version
    name      = helm_release.autoscaler.name
  }

  depends_on = [
    helm_release.autoscaler
  ]
}