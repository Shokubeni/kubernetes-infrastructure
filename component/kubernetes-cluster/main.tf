terraform {
  backend "s3" {}
}

provider "aws" {
  profile = var.provider_profile
  region  = var.provider_region
  version = ">= 1.50.0"
}

module "common" {
  source = "./module/common"

  runtime_config     = var.nodes_runtime_config
  cluster_label      = var.cluster_label
  cluster_name       = var.cluster_name
}

module "network" {
  source = "./module/network"

  cluster_config     = module.common.cluster_config
  network_config     = var.network_config
}

module "security" {
  source = "./module/security"

  cluster_config     = module.common.cluster_config
  backup_bucket      = module.common.backup_bucket
  secure_bucket      = module.common.secure_bucket
  master_queue       = module.common.master_queue
  worker_queue       = module.common.worker_queue
  network_data       = module.network.network_data
}

module "workload" {
  source = "./module/workload"

  backup_bucket      = module.common.backup_bucket
  secure_bucket      = module.common.secure_bucket
  backup_user        = module.security.backup_user
}

module "balancer" {
  source = "./module/balancer"

  balancer_security  = module.security.balancer
  nat_node_security  = module.security.nat_node
  cluster_config     = module.common.cluster_config
  network_data       = module.network.network_data
  network_config     = var.network_config
}

module "lambda" {
  source = "./module/lambda"

  cluster_config     = module.common.cluster_config
  runtime_config     = var.nodes_runtime_config
  system_commands    = module.common.system_command
  secure_bucket      = module.common.secure_bucket
  backup_bucket      = module.common.backup_bucket
  balancer_data      = module.balancer.balancer_data
  master_queue       = module.common.master_queue
  worker_queue       = module.common.worker_queue
  cloudwatch_role    = module.security.cloudwatch_event
  worker_role        = module.security.worker_lifecycle
  master_role        = module.security.master_lifecycle
}

module "master" {
  source = "./module/compute"

  cluster_role       = ["controlplane"]
  cluster_config     = module.common.cluster_config
  network_data       = module.network.network_data
  balancer_data      = module.balancer.balancer_data
  lifecycle_queue    = module.common.master_queue
  lifecycle_function = module.lambda.master_lifecycle
  publish_role       = module.security.master_publish
  node_security      = module.security.master_node
  node_config        = var.master_node_config
}

module "worker" {
  source = "./module/compute"

  cluster_role       = ["worker"]
  cluster_config     = module.common.cluster_config
  network_data       = module.network.network_data
  balancer_data      = module.balancer.balancer_data
  lifecycle_queue    = module.common.worker_queue
  lifecycle_function = module.lambda.worker_lifecycle
  publish_role       = module.security.worker_publish
  node_security      = module.security.worker_node
  node_config        = var.worker_node_config
}

module "finalize" {
  source = "./module/finalize"

  secure_bucket      = module.common.secure_bucket
  cluster_config     = module.common.cluster_config
  backup_function    = module.lambda.cluster_backup
  renew_function     = module.lambda.renew_token
  runtime_config     = var.nodes_runtime_config
  root_dir           = var.root_dir
  dependencies       = [
    module.master.autoscaling["group_id"],
    module.worker.autoscaling["group_id"]
  ]
}
