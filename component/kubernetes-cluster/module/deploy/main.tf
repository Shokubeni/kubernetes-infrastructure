data "aws_eks_cluster" "cluster" {
  name = var.control_plane.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.control_plane.id
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    host                   = data.aws_eks_cluster.cluster.endpoint
    load_config_file       = false
  }
  version = "1.1.1"
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  host                   = data.aws_eks_cluster.cluster.endpoint
  load_config_file       = false
  version                = "1.11.1"
}

module "autoscaler" {
  source = "./module/autoscaler"

  openid_provider = var.openid_provider
  control_plane   = var.control_plane
  cluster_data    = var.cluster_data
  root_dir        = var.root_dir
}

module "velero" {
  source = "./module/velero"

  openid_provider = var.openid_provider
  control_plane   = var.control_plane
  runtime_config  = var.runtime_config
  cluster_data    = var.cluster_data
  root_dir        = var.root_dir
}

module "istio" {
  source = "./module/istio"

  control_plane = var.control_plane
  root_dir      = var.root_dir
}