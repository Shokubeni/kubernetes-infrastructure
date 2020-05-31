variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    vpn_clients_cidr   = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)

    domain_info        = object({
      private_zone = string
      public_zone  = string
      domain_name  = string
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
