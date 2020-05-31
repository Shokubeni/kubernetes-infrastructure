module "authentication" {
  source = "./module/authentication"

  control_plane_endpoint = module.control-plane.control_plane_endpoint
  control_plane_iossuer  = module.control-plane.control_plane_issuer
  control_plane_id       = module.control-plane.control_plane_id
  runtime_config         = var.runtime_config
  control_plane          = var.control_plane
  woker_node             = var.woker_node
  cluster_data           = var.cluster_data
  root_dir               = var.root_dir
}

module "control-plane" {
  source = "./module/control-plane"

  runtime_config = var.runtime_config
  control_plane  = var.control_plane
  network_data   = var.network_data
  cluster_data   = var.cluster_data
}