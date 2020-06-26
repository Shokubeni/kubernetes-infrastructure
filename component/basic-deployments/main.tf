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

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.kubernetes.outputs.control_plane.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.kubernetes.outputs.control_plane.id
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    host                   = data.aws_eks_cluster.cluster.endpoint
    load_config_file       = false
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  host                   = data.aws_eks_cluster.cluster.endpoint
  load_config_file       = false
}

provider "aws" {
  profile = var.provider_profile
  region  = var.provider_region
}

module "dns_configuration" {
  source = "./module/dns-configuration"

  balancer_host  = data.terraform_remote_state.kubernetes.outputs.balancer_hostname
  network_config = var.network_config
}

module "basic_deployments" {
  source = "./module/basic-deployments"

  openid_provider = data.terraform_remote_state.kubernetes.outputs.openid_provider
  cluster_data    = data.terraform_remote_state.kubernetes.outputs.cluster_data
  network_config  = var.network_config
  root_dir        = var.root_dir
}

module "monitoring_tools" {
  source = "./module/monitoring-tools"

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
