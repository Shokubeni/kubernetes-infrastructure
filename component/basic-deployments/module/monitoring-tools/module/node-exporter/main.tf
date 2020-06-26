resource "helm_release" "node_exporter" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/module/node-exporter/chart"
  namespace = var.chart_namespace
  name      = "node-exporter"

  depends_on = [
    var.chart_namespace
  ]
}