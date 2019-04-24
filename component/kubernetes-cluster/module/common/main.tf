module "cluster_initialize" {
  source = "./module/cluster_initialize"

  cluster_label = "${var.cluster_label}"
  cluster_name  = "${var.cluster_name}"
}

module "secure_bucket" {
  source = "./module/secure_bucket"

  cluster_label = "${var.cluster_label}"
  cluster_name  = "${var.cluster_name}"
  bucket_region = "${module.cluster_initialize.region_name}"
  cluster_id    = "${module.cluster_initialize.cluster_id}"
}

module "lifecycle_queue" {
  source = "./module/lifecycle_queue"

  cluster_label = "${var.cluster_label}"
  cluster_name  = "${var.cluster_name}"
  cluster_id    = "${module.cluster_initialize.cluster_id}"
}

module "ssm_command" {
  source = "./module/ssm_command"

  cluster_label = "${var.cluster_label}"
  cluster_name  = "${var.cluster_name}"
  cluster_id    = "${module.cluster_initialize.cluster_id}"
}