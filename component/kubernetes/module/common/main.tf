module "cluster_initialize" {
  source = "./module/cluster_initialize"
}

module "ssm_command" {
  source = "./module/ssm_command"

  cluster_id     = "${module.cluster_initialize.cluster_id}"
  cluster_config = "${var.cluster_config}"
}