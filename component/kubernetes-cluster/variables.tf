variable "worker_configs" {
  type = list(object({
    instance = object({
      node_group_label    = string
      instance_types      = list(string)
      shutdown_behavior   = string
      cpu_credits         = string
      disable_termination = bool
      ebs_optimized       = bool
      monitoring          = bool
      max_price           = number
      min_size            = number
      max_size            = number
      on_demand_capasity  = number
      desired_capacity    = number
      kubelet_extra_args  = map(list(string))
    })

    volume = object({
      termination = bool
      volume_type = string
      volume_size = number
      iops        = number
    })
  }))
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

variable "provider_profile" {
  type = string
}

variable "provider_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_label" {
  type = string
}

variable "root_dir" {
  type = string
}