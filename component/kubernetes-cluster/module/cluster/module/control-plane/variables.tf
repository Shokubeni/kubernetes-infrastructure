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

    backups = object({
      schedule   = string
      lifetime   = string
      namespaces = list(string)
      resources  = list(string)
    })

    logs = object({
      retention = number
      types     = list(string)
    })
  })
}

variable "network_data" {
  type = object({
    internet_gateway_id = string
    private_subnet_ids  = list(string)
    public_subnet_ids   = list(string)
    virtual_cloud_id    = string
  })
}

variable "control_plane" {
  type = object({
    group_id  = string
    group_arn = string
    role_id   = string
    role_arn  = string
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
