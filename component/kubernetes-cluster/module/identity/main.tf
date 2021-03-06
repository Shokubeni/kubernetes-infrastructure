module "security_group" {
  source = "./module/security-group"

  virtual_cloud_id = var.network_data.virtual_cloud_id
  cluster_data     = var.cluster_data
}

module "entity_iam_role" {
  source = "./module/entity-iam-role"

  cluster_data   = var.cluster_data
}
