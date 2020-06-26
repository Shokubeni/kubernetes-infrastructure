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
    name  = "vpnCidr"
    value = var.network_config.vpn_clients_cidr
  }

  set {
    name  = "auth.clientId"
    value = var.grafana_client_id
  }

  set {
    name  = "auth.secret"
    value = var.grafana_secret
  }

  set {
    name  = "smtp.from"
    value = "metrics@${var.network_config.domain_info.domain_name}"
  }

  set {
    name  = "smtp.host"
    value = base64encode("${var.smtp_config.host}:${var.smtp_config.port}")
  }

  set {
    name  = "smtp.user"
    value = base64encode(var.smtp_config.metrics_user)
  }

  set {
    name  = "smtp.pass"
    value = base64encode(var.smtp_config.metrics_pass)
  }

  depends_on = [
    var.chart_namespace
  ]
}