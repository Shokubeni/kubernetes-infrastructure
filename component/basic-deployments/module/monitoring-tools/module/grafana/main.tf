resource "helm_release" "grafana" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/module/grafana/chart"
  namespace = var.chart_namespace
  name      = "grafana"

  set {
    name  = "domainName"
    value = var.network_config.domain_info.domain_name
  }

  set {
    name  = "serverUrl"
    value = "https://metrics.${var.network_config.domain_info.domain_name}"
  }

  set {
    name  = "auth.clientId"
    value = var.grafana_client_id
  }

  set {
    name  = "auth.secret"
    value = var.grafana_secret
  }

  depends_on = [
    var.chart_namespace
  ]
}