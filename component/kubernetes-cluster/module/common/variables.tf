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
      schedule     = string
      lifetime     = string
      namespaces   = list(string)
      resources    = list(string)
    })

    cluster = object({
      kubernetes   = string
      docker       = string
    })
  })
}

variable "cluster_name" {
  type = string
}

variable "cluster_label" {
  type = string
}
