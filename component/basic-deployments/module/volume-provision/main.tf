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

/* -------------------------------------------------------------------------- */

module "elastic_filesystem_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/elastic-filesystem/rbac.yaml"
  config_path = var.config_path
}

module "elastic_filesystem_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/elastic-filesystem/configmap.yaml"
  config_path = var.config_path
  variables   = {
    filesystem_dns = aws_efs_file_system.efs.dns_name
    filesystem_id  = aws_efs_file_system.efs.id
    domain_name    = var.network_config.domain_info.domain_name
    cluster_region = var.cluster_config.region
  }
}

module "elastic_filesystem_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/elastic-filesystem/daemonset.yaml"
  config_path = var.config_path
  variables   = {
    filesystem_dns = aws_efs_file_system.efs.dns_name
    filesystem_id  = aws_efs_file_system.efs.id
    cluster_region = var.cluster_config.region
  }
}

module "elastic_filesystem_storageclass" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/elastic-filesystem/storageclass.yaml"
  config_path = var.config_path
  variables   = {
    domain_name = var.network_config.domain_info.domain_name
  }
}

/* -------------------------------------------------------------------------- */

module "block-storage_storageclass" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/block-storage/storageclass.yaml"
  config_path = var.config_path
}