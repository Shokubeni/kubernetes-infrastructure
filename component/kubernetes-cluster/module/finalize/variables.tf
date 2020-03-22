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

variable "secure_bucket" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
  })
}

variable "backup_function" {
  type = object({
    id  = string
    arn = string
  })
}

variable "renew_function" {
  type = object({
    id  = string
    arn = string
  })
}

variable "dependencies" {
  type = list(string)
}

variable "root_dir" {
  type = string
}
