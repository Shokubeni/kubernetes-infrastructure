output "balancer_data" {
  value = {
    internal_hostname = data.kubernetes_service.internal.load_balancer_ingress.0.hostname
    external_hostname = data.kubernetes_service.external.load_balancer_ingress.0.hostname
  }

  depends_on = [
    helm_release.istio
  ]
}