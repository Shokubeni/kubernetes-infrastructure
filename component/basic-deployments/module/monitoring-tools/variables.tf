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

variable "telegram_token" {
  type = string
}

variable "telegram_admin" {
  type = string
}

variable "grafana_client_id" {
  type = string
}

variable "grafana_secret" {
  type = string
}

variable "root_dir" {
  type = string
}
