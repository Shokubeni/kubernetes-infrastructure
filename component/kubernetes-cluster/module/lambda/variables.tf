variable "system_commands" {
  type = object({
    node_runtime_install   = string
    general_master_init    = string
    general_master_restore = string
    stacked_master_init    = string
    common_worker_init     = string
    cluster_etcd_backup    = string
    renew_join_token       = string
  })
}

variable "runtime_config" {
  type = object({
    token_schedule = string

    backups = object({
      schedule     = string
      ttl          = string
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

variable "backup_bucket" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
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

variable "master_queue" {
  type = object({
    id   = string
    arn  = string
    name = string
  })
}

variable "worker_queue" {
  type = object({
    id   = string
    arn  = string
    name = string
  })
}

variable "cloudwatch_role" {
  type = object({
    id  = string
    arn = string
  })
}

variable "master_role" {
  type = object({
    id  = string
    arn = string
  })
}

variable "worker_role" {
  type = object({
    id  = string
    arn = string
  })
}

variable "balancer_data" {
  type = object({
    zone = string
    dns  = string
    id   = string
  })
}
