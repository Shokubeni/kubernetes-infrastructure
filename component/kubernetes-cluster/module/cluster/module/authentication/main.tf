data "aws_eks_cluster" "cluster" {
  name = var.control_plane_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.control_plane_id
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  host                   = data.aws_eks_cluster.cluster.endpoint
  load_config_file       = false
}

resource "null_resource" "wait_for_cluster" {
  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command = <<EOT
      for i in `seq 1 60`
      do
       wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true
       sleep 5
      done
      echo TIMEOUT && exit 1
    EOT
    environment = {
      ENDPOINT = var.control_plane_endpoint
    }
  }
}

resource "kubernetes_config_map" "cluster_auth" {
  data = {
    mapAccounts = yamlencode(var.runtime_config.auth_accounts)
    mapUsers    = yamlencode(var.runtime_config.auth_users)
    mapRoles    = yamlencode(concat(
      var.runtime_config.auth_roles,
      local.worker_provision_roles,
    ))
  }

  metadata {
    namespace = "kube-system"
    name      = "aws-auth"
  }

  depends_on = [
    null_resource.wait_for_cluster
  ]
}

locals {
  worker_provision_roles = [{
    username = "system:node:{{EC2PrivateDNSName}}"
    rolearn  = var.worker_node.role_arn
    groups = [
      "system:bootstrappers",
      "system:nodes",
    ]
  }]
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = var.control_plane_iossuer
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  client_id_list  = ["sts.amazonaws.com"]
}

resource "local_file" "kubeconfig" {
  filename = "${var.root_dir}/output/${var.cluster_data.id}/kubernetes.conf"
  content = templatefile("${path.module}/template/kubeconfig.tpl", {
    cluster_cert  = data.aws_eks_cluster.cluster.certificate_authority.0.data
    endpoint_url  = data.aws_eks_cluster.cluster.endpoint
    cluster_name  = data.aws_eks_cluster.cluster.name
    auth_roles    = var.runtime_config.auth_roles
  })
}
