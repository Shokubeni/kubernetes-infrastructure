module "security_group" {
  source = "./module/security_group"

  virtual_cloud_id = "${var.virtual_cloud_id}"
  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}

module "instance_role" {
  source = "./module/instance_role"

  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}

module "lambda_role" {
  source = "./module/lambda_role"

  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}

module "publish_role" {
  source = "./module/publish_role"

  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}

module "tls_key_pair" {
  source = "./module/tls_key_pair"

  cluster_config   = "${var.cluster_config}"
  cluster_id       = "${var.cluster_id}"
}