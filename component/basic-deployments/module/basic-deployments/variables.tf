variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    vpn_clients_cidr   = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)
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

variable "cluster_config" {
  type = object({
    id      = string
    name    = string
    label   = string
    account = string
    region  = string
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

variable "root_dir" {
  type = string
}
