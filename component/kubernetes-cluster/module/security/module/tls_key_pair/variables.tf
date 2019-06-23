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