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

variable "master_queue" {
  type = string
}

variable "worker_queue" {
  type = string
}
