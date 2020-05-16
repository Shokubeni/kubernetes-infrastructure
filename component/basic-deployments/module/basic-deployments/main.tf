locals {
  public_subnets = var.network_data.public_subnet_ids
}

resource "aws_security_group" "efs" {
  name   = "${var.cluster_config.label}-efs_${var.cluster_config.id}"
  vpc_id = var.network_data.virtual_cloud_id

  ingress {
    description = "Allows NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.network_config.virtual_cloud_cidr]
  }

  egress {
    description = "Allows NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.network_config.virtual_cloud_cidr]
  }

  tags = {
    "Name" = "${var.cluster_config.name} Network Filesystem",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "${var.cluster_config.label}.${var.cluster_config.id}"

  tags = {
    "Name" = "${var.cluster_config.name} Cluster Filesystem",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}

resource "aws_efs_mount_target" "efs" {
  count = length(local.public_subnets)

  subnet_id       = local.public_subnets[count.index]
  file_system_id  = aws_efs_file_system.efs.id
  security_groups = [aws_security_group.efs.id]
}

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

resource "helm_release" "ebs_block_storage" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/charts/ebs-block-storage"
  name      = "ebs-block-storage"
  namespace = "basic-deployments"

  depends_on = [
    kubernetes_namespace.basic_deployments
  ]
}

data "template_file" "elastic-filesystem" {
  template = file("${path.module}/charts/elastic-filesystem/values.yaml")

  vars = {
    domain_name    = var.network_config.domain_info.domain_name
    cluster_region = var.cluster_config.region
    efs_dns_name   = aws_efs_file_system.efs.dns_name
    efs_id         = aws_efs_file_system.efs.id
  }
}

resource "helm_release" "elastic_filesystem" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/charts/elastic-filesystem"
  name      = "elastic-filesystem"
  namespace = "basic-deployments"

  values = [
    data.template_file.elastic-filesystem.rendered
  ]

  depends_on = [
    kubernetes_namespace.basic_deployments
  ]
}
