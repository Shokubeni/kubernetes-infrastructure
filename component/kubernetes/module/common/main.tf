module "cluster_initialize" {
  source = "./module/cluster_initialize"

  cluster_config = "${var.cluster_config}"
}

module "secure_bucket" {
  source = "./module/secure_bucket"

  cluster_config = "${var.cluster_config}"
  cluster_id     = "${module.cluster_initialize.cluster_id}"
}

module "lifecycle_queue" {
  source = "./module/lifecycle_queue"

  cluster_config = "${var.cluster_config}"
  cluster_id     = "${module.cluster_initialize.cluster_id}"
}

module "ssm_command" {
  source = "./module/ssm_command"

  cluster_config = "${var.cluster_config}"
  cluster_id     = "${module.cluster_initialize.cluster_id}"
}