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

variable "cluster_config" {
  type = object({
    id         = string
    name       = string
    label      = string
    account    = string
    region     = string
    type       = string
  })
}
