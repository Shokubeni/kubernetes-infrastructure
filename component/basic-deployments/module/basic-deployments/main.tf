module "cert_manager" {
  source = "./module/cert-manager"

  openid_provider = var.openid_provider
  network_config  = var.network_config
  cluster_data    = var.cluster_data
  root_dir        = var.root_dir
}

module "open_vpn" {
  source = "./module/open-vpn"

  network_config = var.network_config
  root_dir       = var.root_dir
}

module "ebs_storage" {
  source = "./module/ebs-storage"

  root_dir = var.root_dir
}