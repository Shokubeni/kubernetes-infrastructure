resource "helm_release" "ebs_storage" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/module/ebs-storage/chart"
  namespace = var.chart_namespace
  name      = "ebs-storage"

  depends_on = [
    var.chart_namespace
  ]
}