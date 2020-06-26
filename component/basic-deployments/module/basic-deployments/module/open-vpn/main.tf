resource "helm_release" "open_vpn" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/module/open-vpn/chart"
  namespace = var.chart_namespace
  name      = "open-vpn"

  set {
    name  = "domainName"
    value = var.network_config.domain_info.domain_name
  }

  depends_on = [
    var.chart_namespace
  ]
}