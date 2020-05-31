variable "cluster_data" {
  type = object({
    id      = string
    name    = string
    label   = string
    account = string
    region  = string
  })
}
