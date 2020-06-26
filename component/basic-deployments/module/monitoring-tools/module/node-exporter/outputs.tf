output "node_exporter" {
  value = {
    namespace = helm_release.node_exporter.namespace
    version   = helm_release.node_exporter.version
    name      = helm_release.node_exporter.name
  }

  depends_on = [
    helm_release.node_exporter
  ]
}