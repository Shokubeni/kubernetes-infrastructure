variable "virtual_cloud_id" {
  type = string
}

variable "subnets_zones" {
  type = list(string)
}

variable "subnets_cidrs" {
  type = list(string)
}

variable "cluster_data" {
  type = object({
    id      = string
    name    = string
    label   = string
    account = string
    region  = string
  })
}
