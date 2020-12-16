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

variable "control_plane_endpoint" {
  type = string
}

variable "control_plane_iossuer" {
  type = string
}

variable "control_plane_id" {
  type = string
}

variable "control_plane" {
  type = object({
    group_id  = string
    group_arn = string
    role_id   = string
    role_arn  = string
  })
}

variable "worker_node" {
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

variable "root_dir" {
  type = string
}