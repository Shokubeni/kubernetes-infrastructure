module "security_groups" {
  source = "./module/security_groups"

  virtual_cloud_id = "${var.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
}

module "iam_roles" {
  source = "./module/iam_roles"

  cluster_config = "${var.cluster_config}"
}

module "key_pairs" {
  source = "./module/key_pairs"

  cluster_config = "${var.cluster_config}"
}