output "prometheus" {
  value = {
    namespace = helm_release.prometheus.namespace
    version   = helm_release.prometheus.version
    name      = helm_release.prometheus.name
  }

  depends_on = [
    helm_release.prometheus
  ]
}