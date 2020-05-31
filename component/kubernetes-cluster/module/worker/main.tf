module "launch_tempate" {
  source = "./module/launch_template"

  worker_configs = var.worker_configs
  runtime_config = var.runtime_config
  control_plane  = var.control_plane
  worker_node  = var.worker_node
  cluster_data   = var.cluster_data
}

module "autoscaling_group" {
  source = "./module/autoscaling_group"

  template_ids   = module.launch_tempate.launch_template_ids
  worker_configs = var.worker_configs
  network_data   = var.network_data
  cluster_data   = var.cluster_data
}