resource "helm_release" "open_vpn" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/module/open-vpn/chart"
  namespace = "kube-system"
  name      = "open-vpn"

  set {
    name  = "domainName"
    value = var.network_config.domain_info.domain_name
  }
}