variable "network_data" {
  type = object({
    internet_gateway_id = string
    private_subnet_ids  = list(string)
    public_subnet_ids   = list(string)
    virtual_cloud_id    = string
  })
}

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

variable "nat_node_security" {
  type = object({
    group_id    = string
    private_key = string
    public_key  = string
    key_id      = string
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
