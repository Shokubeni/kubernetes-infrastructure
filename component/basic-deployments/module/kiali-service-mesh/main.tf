resource "helm_release" "kiali" {
  chart     = "${var.root_dir}/component/basic-deployments/module/kiali-service-mesh/chart"
  namespace = "istio-system"
  name      = "kiali"

  set {
    name  = "domainName"
    value = var.network_config.domain_info.domain_name
  }

  set {
    name  = "auth.clientId"
    value = var.kiali_client_id
  }

  set {
    name  = "auth.secret"
    value = var.kiali_secret
  }
}
