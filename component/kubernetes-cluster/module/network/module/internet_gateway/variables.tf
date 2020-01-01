variable "virtual_cloud_id" {
  type = string
}

variable "public_subnets_count" {
  type = string
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "private_subnets_count" {
  type = string
}

variable "private_subnets_ids" {
  type = list(string)
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
