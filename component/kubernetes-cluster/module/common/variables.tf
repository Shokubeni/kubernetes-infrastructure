variable "runtime_config" {
  type = object({
    token_schedule  = string
    is_prod_env     = bool

    backups = object({
      schedule      = string
      ttl           = string
      namespaces    = list(string)
      resources     = list(string)
    })

    cluster = object({
      kubernetes    = string
      docker        = string
    })
  })
}

variable "deployment_type" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_label" {
  type = string
}
