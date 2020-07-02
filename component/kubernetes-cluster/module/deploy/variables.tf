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

variable "runtime_config" {
  type = object({
    k8s_version = string

    auth_accounts = list(string)

    auth_users = list(object({
      userarn  = string
      username = string
      groups   = list(string)
    }))

    auth_roles = list(object({
      rolearn  = string
      username = string
      groups   = list(string)
    }))

    backups = list(object({
      name     = string
      schedule = string
      lifetime = string
      include = object({
        namespaces = list(string)
        resources  = list(string)
      })
      exclude = object({
        namespaces = list(string)
        resources  = list(string)
      })
    }))

    logs = object({
      retention = number
      types     = list(string)
    })
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

variable "root_dir" {
  type = string
}