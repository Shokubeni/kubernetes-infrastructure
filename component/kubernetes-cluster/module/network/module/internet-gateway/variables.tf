variable "virtual_cloud_id" {
  type = string
}

variable "subnets_ids" {
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
