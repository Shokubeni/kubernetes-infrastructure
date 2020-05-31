data "aws_eks_cluster" "cluster" {
  name = var.control_plane.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.control_plane.id
}

provider "helm" {
  version = "~> 1.1"
  kubernetes {
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    host                   = data.aws_eks_cluster.cluster.endpoint
    load_config_file       = false
  }
}

module "istio" {
  source = "./module/istio"

  control_plane = var.control_plane
  root_dir      = var.root_dir
}

module "velero" {
  source = "./module/velero"

  control_plane = var.control_plane
  cluster_data  = var.cluster_data
  bucket_data   = var.bucket_data
  root_dir      = var.root_dir
}