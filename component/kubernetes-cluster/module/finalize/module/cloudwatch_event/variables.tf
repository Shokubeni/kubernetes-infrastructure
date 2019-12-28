variable "runtime_config" {
  type = object({
    token_schedule = string

    backups = object({
      schedule     = string
      ttl          = string
      resources    = list(string)
    })

    cluster = object({
      kubernetes   = string
      docker       = string
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
    type       = string
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
