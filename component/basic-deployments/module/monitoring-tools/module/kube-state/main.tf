resource "helm_release" "kube_state" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/module/kube-state/chart"
  namespace = var.chart_namespace
  name      = "kube-state"

  depends_on = [
    var.chart_namespace
  ]
}