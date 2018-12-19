module "key_pairs" {
  source = "./module/key_pairs"

  cluster_info = "${var.cluster_info}"
}