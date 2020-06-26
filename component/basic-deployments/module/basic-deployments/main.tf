resource "kubernetes_namespace" "basic_deployments" {
  metadata {
    labels = {
      "istio-injection" = "enabled"
    }

    name = "basic-deployments"
  }
}

module "cert_manager" {
  source = "./module/cert-manager"

  chart_namespace = kubernetes_namespace.basic_deployments.metadata[0].name
  openid_provider = var.openid_provider
  network_config  = var.network_config
  cluster_data    = var.cluster_data
  root_dir        = var.root_dir
}

module "ebs_storage" {
  source = "./module/ebs-storage"

  chart_namespace = kubernetes_namespace.basic_deployments.metadata[0].name
  root_dir        = var.root_dir
}

module "open_vpn" {
  source = "./module/open-vpn"

  chart_namespace = kubernetes_namespace.basic_deployments.metadata[0].name
  network_config  = var.network_config
  root_dir        = var.root_dir
}