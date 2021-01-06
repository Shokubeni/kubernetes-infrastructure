output "kiali" {
  value = {
    namespace = helm_release.kiali.namespace
    version   = helm_release.kiali.version
    name      = helm_release.kiali.name
  }

  depends_on = [
    helm_release.kiali
  ]
}