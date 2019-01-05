module "security_group" {
  source = "./module/security_group"

  virtual_cloud_id = "${var.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}

module "autoscaling_role" {
  source = "./module/autoscaling_role"

  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}

module "node_role" {
  source = "./module/node_role"

  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}

module "tls_key_pair" {
  source = "./module/tls_key_pair"

  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}