output "cert_manager" {
  value = {
    namespace = helm_release.cert_manager.namespace
    version   = helm_release.cert_manager.version
    name      = helm_release.cert_manager.name
  }

  depends_on = [
    helm_release.cert_manager
  ]
}