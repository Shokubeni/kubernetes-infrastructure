variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    vpn_clients_cidr   = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)

    private_services = list(object({
      name: string
      ports: object({
        gateway: number
        service: number
      })
    }))

    public_services = list(object({
      name: string
      ports: object({
        gateway: number
        service: number
      })
    }))

    domain_info = object({
      public_zone = string
      domain_name = string
    })
  })
}

variable "cluster_data" {
  type = object({
    id      = string
    name    = string
    label   = string
    account = string
    region  = string
  })
}
