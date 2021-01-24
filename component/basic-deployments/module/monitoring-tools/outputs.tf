output "alertmanager_bot" {
  value = module.alertmanager_bot.alertmanager_bot
}

output "alertmanager" {
  value = module.alertmanager.alertmanager
}

output "node_exporter" {
  value = module.node_exporter.node_exporter
}

output "prometheus" {
  value = module.prometheus.prometheus
}

output "kube_state" {
  value = module.kube_state.kube_state
}

output "grafana" {
  value = module.grafana.grafana
}