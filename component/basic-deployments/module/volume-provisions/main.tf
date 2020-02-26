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

data "template_file" "volume_provisions" {
  template = file("${path.module}/chart/values.yaml")

  vars = {
    domain_name    = var.network_config.domain_info.domain_name
    cluster_region = var.cluster_config.region
    efs_dns_name   = aws_efs_file_system.efs.dns_name
    efs_id         = aws_efs_file_system.efs.id
  }
}

resource "helm_release" "volume_provisions" {
  chart     = "${path.module}/chart"
  name      = "volume-provisions"
  namespace = "kube-system"

  values = [
    data.template_file.volume_provisions.rendered
  ]
}
