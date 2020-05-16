variable "secure_bucket" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
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

variable "backup_user" {
  type = object({
    id  = string
    arn = string
  })
}