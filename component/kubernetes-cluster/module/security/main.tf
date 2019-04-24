module "security_group" {
  source = "./module/security_group"

  virtual_cloud_id = "${var.network_data["virtual_cloud_id"]}"
  cluster_config   = "${var.cluster_config}"
}

module "instance_role" {
  source = "./module/instance_role"

  cluster_config   = "${var.cluster_config}"
  bucket_name      = "${var.secure_bucket["id"]}"
}

module "lambda_role" {
  source = "./module/lambda_role"

  cluster_config   = "${var.cluster_config}"
  master_queue     = "${var.master_queue["name"]}"
  worker_queue     = "${var.worker_queue["name"]}"
}

module "publish_role" {
  source = "./module/publish_role"

  cluster_config   = "${var.cluster_config}"
  master_queue     = "${var.master_queue["name"]}"
  worker_queue     = "${var.worker_queue["name"]}"
}

module "tls_key_pair" {
  source = "./module/tls_key_pair"

  cluster_config   = "${var.cluster_config}"
}