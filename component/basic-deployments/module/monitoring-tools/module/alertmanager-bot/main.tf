resource "helm_release" "alertmanager_bot" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/module/alertmanager-bot/chart"
  namespace = var.chart_namespace
  name      = "alertmanager-bot"

  set {
    name  = "telegram.admin"
    value = base64encode(var.telegram_admin)
  }

  set {
    name  = "telegram.token"
    value = base64encode(var.telegram_token)
  }

  depends_on = [
    var.chart_namespace
  ]
}