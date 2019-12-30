variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    nat_instance_type  = string
    is_main_cluster    = bool
    private_subnets    = map(string)
    public_subnets     = map(string)
    tcp_services       = map(string)
    udp_services       = map(string)
    domain_info        = object({
      hosted_zone = string
      domain_name = string
    })
  })
}

variable "balancer_data" {
  type = object({
    dns  = string
    id   = string
    zone = string
  })
}

variable "provider_profile" {
  type = string
}

variable "provider_region" {
  type = string
}
