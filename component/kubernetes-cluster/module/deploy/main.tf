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
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  host                   = data.aws_eks_cluster.cluster.endpoint
}

module "aws-autoscaler" {
  source = "./module/aws-autoscaler"

  openid_provider = var.openid_provider
  control_plane   = var.control_plane
  cluster_data    = var.cluster_data
  root_dir        = var.root_dir
}

module "cert_manager" {
  source = "./module/cert-manager"

  openid_provider = var.openid_provider
  network_config  = var.network_config
  control_plane   = var.control_plane
  cluster_data    = var.cluster_data
  root_dir        = var.root_dir
}

module "ebs_storage" {
  source = "./module/ebs-storage"

  control_plane = var.control_plane
  cluster_data  = var.cluster_data
  root_dir      = var.root_dir
}

module "velero" {
  source = "./module/velero"

  openid_provider = var.openid_provider
  control_plane   = var.control_plane
  runtime_config  = var.runtime_config
  cluster_data    = var.cluster_data
  root_dir        = var.root_dir
}