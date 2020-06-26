variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    vpn_clients_cidr   = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)

    domain_info = object({
      private_zone = string
      public_zone  = string
      domain_name  = string
    })
  })
}

variable "chart_namespace" {
  type = string
}

variable "root_dir" {
  type = string
}