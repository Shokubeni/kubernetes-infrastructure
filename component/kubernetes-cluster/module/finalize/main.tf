resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

module "cloudwatch_event" {
  source = "./module/cloudwatch_event"

  cluster_config  = var.cluster_config
  backup_function = var.backup_function
  renew_function  = var.renew_function
  runtime_config  = var.runtime_config
  dependencies    = var.dependencies
}

module "kubernetes_output" {
  source = "./module/kubernetes_output"

  secure_bucket   = var.secure_bucket
  cluster_config  = var.cluster_config
  dependencies    = var.dependencies
  root_dir        = var.root_dir
}
