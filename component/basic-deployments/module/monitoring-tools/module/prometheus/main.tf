resource "helm_release" "prometheus" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/module/prometheus/chart"
  namespace = var.chart_namespace
  name      = "prometheus"

  depends_on = [
    var.chart_namespace
  ]
}