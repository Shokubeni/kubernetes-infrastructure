resource "helm_release" "alertmanager" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/module/alertmanager/chart"
  namespace = var.chart_namespace
  name      = "alertmanager"

  depends_on = [
    var.chart_namespace
  ]
}