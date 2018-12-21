module "key_pairs" {
  source = "./module/key_pairs"
}

module "security_groups" {
  source = "./module/security_groups"

  cluster_info = "${var.cluster_info}"
  vpc_id       = "${var.vpc_id}"
}