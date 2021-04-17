output "balancer_hostname" {
  value = data.kubernetes_service.balancer.status.0.load_balancer.0.ingress.0.hostname

  depends_on = [
    helm_release.istio
  ]
}