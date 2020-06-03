output "balancer_hostname" {
  value = data.kubernetes_service.example.load_balancer_ingress.0.hostname
}
