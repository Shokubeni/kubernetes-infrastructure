terraform {
  backend "s3" {}
}

data "terraform_remote_state" "kubernetes" {
  backend = "s3"

  config = {
    key    = "kubernetes-cluster/terraform.tfstate"
    bucket = var.backend_bucket
    region = var.backend_region
  }
}

locals {
  config_path    = var.kube_config == "false" ? data.terraform_remote_state.kubernetes.outputs.config_path : var.kube_config
  cluster_config = data.terraform_remote_state.kubernetes.outputs.cluster_config
  balancer_data  = data.terraform_remote_state.kubernetes.outputs.balancer_data
  network_data   = data.terraform_remote_state.kubernetes.outputs.network_data
}

provider "helm" {
  kubernetes {
    config_path = local.config_path
  }
}

provider "kubernetes" {
  config_context = "kubernetes-admin@${data.terraform_remote_state.kubernetes.outputs.cluster_config.id}"
  config_path    = local.config_path
}

provider "aws" {
  profile = var.provider_profile
  region  = var.provider_region
  version = ">= 2.0"
}

module "dns" {
  source = "./module/dns-configuration"

  balancer_data     = local.balancer_data
  provider_profile  = var.provider_profile
  provider_region   = var.provider_region
  network_config    = var.network_config
}

module "volume" {
  source = "./module/volume-provisions"

  cluster_config    = local.cluster_config
  network_data      = local.network_data
  config_path       = local.config_path
  network_config    = var.network_config
  root_dir          = var.root_dir
}

module "basic" {
  source = "./module/basic-deployments"

  runtime_config    = var.nodes_runtime_config
  cluster_config    = local.cluster_config
  config_path       = local.config_path
  network_config    = var.network_config
  root_dir          = var.root_dir
}

module "monitoring" {
  source = "./module/monitoring-tools"

  cluster_config    = local.cluster_config
  config_path       = local.config_path
  slack_channel     = var.slack_channel
  slack_hook        = var.slack_hook
  grafana_client_id = var.grafana_client_id
  grafana_secret    = var.grafana_secret
  network_config    = var.network_config
  root_dir          = var.root_dir
  smtp_config       = {
    host         = var.smtp_host
    port         = var.smtp_port
    metrics_user = var.smtp_metrics_user
    metrics_pass = var.smtp_metrics_pass
    alerts_user  = var.smtp_alerts_user
    alerts_pass  = var.smtp_alerts_pass
  }
}
