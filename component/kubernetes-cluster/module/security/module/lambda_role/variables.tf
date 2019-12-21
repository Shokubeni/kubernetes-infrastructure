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

variable "master_queue" {
  type = string
}

variable "worker_queue" {
  type = string
}

variable "backup_bucket" {
  type = string
}

variable "bucket_name" {
  type = string
}
