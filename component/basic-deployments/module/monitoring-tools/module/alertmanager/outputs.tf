output "alertmanager" {
  value = {
    namespace = helm_release.alertmanager.namespace
    version   = helm_release.alertmanager.version
    name      = helm_release.alertmanager.name
  }

  depends_on = [
    helm_release.alertmanager
  ]
}