output "grafana" {
  value = {
    namespace = helm_release.grafana.namespace
    version   = helm_release.grafana.version
    name      = helm_release.grafana.name
  }

  depends_on = [
    helm_release.grafana
  ]
}