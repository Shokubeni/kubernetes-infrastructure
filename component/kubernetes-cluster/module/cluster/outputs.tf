output "control_plane" {
  value = {
    authority = module.control-plane.control_plane_authority
    endpont   = module.control-plane.control_plane_endpoint
    config    = module.authentication.config_file
    id        = module.control-plane.control_plane_id
  }
}