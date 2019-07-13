variable "virtual_cloud_id" {
  type = string
}

variable "subnets_count" {
  type = string
}

variable "subnets_zones" {
  type = list(string)
}

variable "subnets_cidrs" {
  type = list(string)
}

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