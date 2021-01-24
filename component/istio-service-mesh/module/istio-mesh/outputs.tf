output "balancer_hostname" {
  value = data.kubernetes_service.balancer.load_balancer_ingress.0.hostname

  depends_on = [
    helm_release.istio
  ]
}