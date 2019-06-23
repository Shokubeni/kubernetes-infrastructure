variable "cluster_config" {
  type = object({
    id         = string
    name       = string
    label      = string
    kubernetes = string
    docker     = string
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