module "cluster_initialize" {
  source = "./module/cluster_initialize"
}

module "secure_bucket" {
  source = "./module/secure_bucket"

  cluster_config = "${var.cluster_config}"
  cluster_id     = "${module.cluster_initialize.cluster_id}"
}

module "ssm_command" {
  source = "./module/ssm_command"

  cluster_config = "${var.cluster_config}"
  cluster_id     = "${module.cluster_initialize.cluster_id}"
}