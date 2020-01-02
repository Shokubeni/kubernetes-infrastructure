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

variable "cluster_bucket" {
  type = string
}

variable "backup_bucket" {
  type = string
}
