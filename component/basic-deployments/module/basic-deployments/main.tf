resource "kubernetes_namespace" "basic_deployments" {
  metadata {
    annotations = {
      "linkerd.io/inject" = "enabled"
    }

    name = "basic-deployments"
  }
}

data "template_file" "iam_authenticator" {
  template = file("${path.module}/charts/iam-authenticator/values.yaml")

  vars = {
    auth_roles = templatefile(
      "${path.module}/charts/iam-authenticator/iam-roles.tpl",
      {iam_roles = var.runtime_config.iam_access}
    )
    cluster_id = var.cluster_config.id
  }
}

resource "helm_release" "iam_authenticator" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/charts/iam-authenticator"
  name      = "iam-authenticator"
  namespace = "basic-deployments"

  values = [
    data.template_file.iam_authenticator.rendered
  ]

  depends_on = [
    kubernetes_namespace.basic_deployments
  ]
}

data "template_file" "acme_cert_manager" {
  template = file("${path.module}/charts/acme-cert-manager/values.yaml")

  vars = {
    domain_name    = var.network_config.domain_info.domain_name
    public_zone    = var.network_config.domain_info.public_zone
    cluster_region = var.cluster_config.region
  }
}

resource "helm_release" "acme_cert_manager" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/charts/acme-cert-manager"
  name      = "acme-cert-manager"
  namespace = "basic-deployments"

  values = [
    data.template_file.acme_cert_manager.rendered
  ]

  depends_on = [
    kubernetes_namespace.basic_deployments
  ]
}

data "template_file" "cluster_autoscaller" {
  template = file("${path.module}/charts/cluster-autoscaler/values.yaml")

  vars = {
    cluster_id = var.cluster_config.id
  }
}

resource "helm_release" "cluster_autoscaller" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/charts/cluster-autoscaler"
  name      = "cluster-autoscaller"
  namespace = "basic-deployments"

  values = [
    data.template_file.cluster_autoscaller.rendered
  ]

  depends_on = [
    kubernetes_namespace.basic_deployments
  ]
}
