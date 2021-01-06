terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.0.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
  }
}

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

module "istio-mesh" {
  source = "./module/istio-mesh"

  control_plane   = data.terraform_remote_state.kubernetes.outputs.control_plane
  network_config  = var.network_config
  root_dir        = var.root_dir
}