variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)

    cluster_services = list(object({
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

variable "openid_provider" {
  type = object({
    arn = string
    url = string
  })
}

variable "control_plane" {
  type = object({
    authority = string
    endpont   = string
    config    = string
    id        = string
  })
}

variable "root_dir" {
  type = string
}