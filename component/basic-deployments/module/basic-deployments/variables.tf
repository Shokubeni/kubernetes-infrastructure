variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    vpn_clients_cidr   = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)
    tcp_services       = list(object({
      namespace = string
      workload  = string
      port      = number
    }))
    udp_services       = list(object({
      namespace = string
      workload  = string
      port      = number
    }))
    domain_info        = object({
      private_zone = string
      public_zone  = string
      domain_name  = string
    })
  })
}

variable "runtime_config" {
  type = object({
    token_schedule = string
    prod_cluster   = bool

    iam_access = list(object({
      groups = list(string)
      role   = string
      name   = string
    }))

    backups = object({
      schedule   = string
      lifetime   = string
      namespaces = list(string)
      resources  = list(string)
    })

    cluster = object({
      authenticator = string
      kubernetes    = string
      docker        = string
      velero        = string
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
    prod       = bool
  })
}

variable "config_path" {
  type = string
}

variable "root_dir" {
  type = string
}
