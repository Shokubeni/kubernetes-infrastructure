//**********************************************************************
//*                     Kubernetes configuration                       *
//**********************************************************************
provider_info = {
  profile = "cluster_operator"
  region  = "eu-west-1"
}

cluster_info = {
  name  = "Kubernetes"
  label = "kubernetes"
}

virtual_cloud_cidr = "172.16.0.0/16"
private_subnets = {
  "172.16.0.0/20"  = "eu-west-1b"
}
public_subnets = {
  "172.16.16.0/20" = "eu-west-1b"
}