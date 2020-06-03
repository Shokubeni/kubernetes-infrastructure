output "control_plane" {
  value = {
    authority = module.control-plane.control_plane_authority
    endpont   = module.control-plane.control_plane_endpoint
    config    = module.authentication.config_file
    id        = module.control-plane.control_plane_id
  }

  depends_on = [
    module.authentication,
    module.control-plane
  ]
}

output "openid_provider" {
  value = {
    arn = module.authentication.openid_arn
    url = module.authentication.openid_url
  }

  depends_on = [
    module.authentication,
    module.control-plane
  ]
}