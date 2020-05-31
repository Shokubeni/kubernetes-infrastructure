terraform {
  backend "s3" {}
}

provider "aws" {
  profile = var.provider_profile
  region  = var.provider_region
  version = "~> 2.60"
}

module "prebuilt" {
  source = "./module/prebuilt"

  cluster_label  = var.cluster_label
  cluster_name   = var.cluster_name
}

module "network" {
  source = "./module/network"

  cluster_data   = module.prebuilt.cluster_data
  network_config = var.network_config
}

module "identity" {
  source = "./module/identity"

  cluster_data   = module.prebuilt.cluster_data
  network_data   = module.network.network_data
  bucket_data    = module.prebuilt.backup_bucket
}

module "gateway" {
  source = "./module/gateway"

  nat_instance   = module.identity.nat_instance
  cluster_data   = module.prebuilt.cluster_data
  network_data   = module.network.network_data
  network_config = var.network_config
}

module "cluster" {
  source = "./module/cluster"

  control_plane  = module.identity.control_plane
  woker_node     = module.identity.worker_node
  network_data   = module.network.network_data
  cluster_data   = module.prebuilt.cluster_data
  runtime_config = var.runtime_config
  root_dir       = var.root_dir
}

module "worker" {
  source = "./module/worker"

  control_plane  = module.cluster.control_plane
  worker_node    = module.identity.worker_node
  network_data   = module.network.network_data
  cluster_data   = module.prebuilt.cluster_data
  runtime_config = var.runtime_config
  worker_configs = var.worker_configs
}

module "deploy" {
  source = "./module/deploy"

  control_plane = module.cluster.control_plane
  bucket_data   = module.prebuilt.backup_bucket
  root_dir      = var.root_dir
}
