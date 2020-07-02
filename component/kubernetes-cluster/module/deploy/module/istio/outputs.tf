output "balancer" {
  value = {
    internal_hostname = data.kubernetes_service.internal.load_balancer_ingress.0.hostname
    external_hostname = data.kubernetes_service.external.load_balancer_ingress.0.hostname
  }
}

output "istio" {
  value = {
    namespace = helm_release.istio.namespace
    version   = helm_release.istio.version
    name      = helm_release.istio.name
  }

  depends_on = [
    helm_release.istio
  ]
}