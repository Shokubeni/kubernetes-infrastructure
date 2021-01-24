output "domain_info" {
  value = {
    public_zone  = var.network_config.domain_info.public_zone
    domain_name  = var.network_config.domain_info.domain_name
  }
}
