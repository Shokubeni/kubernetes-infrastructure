resource "helm_release" "alertmanager" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/module/alertmanager/chart"
  namespace = var.chart_namespace
  name      = "alertmanager"

  set {
    name  = "smtp.from"
    value = "alerts@${var.network_config.domain_info.domain_name}"
  }

  set {
    name  = "smtp.host"
    value = "${var.smtp_config["host"]}:${var.smtp_config["port"]}"
  }

  set {
    name  = "smtp.user"
    value = var.smtp_config.alerts_user
  }

  set {
    name  = "smtp.pass"
    value = var.smtp_config.alerts_pass
  }

  set {
    name  = "slack.channel"
    value = var.slack_channel
  }

  set {
    name  = "slack.hook"
    value = var.slack_hook
  }

  depends_on = [
    var.chart_namespace
  ]
}