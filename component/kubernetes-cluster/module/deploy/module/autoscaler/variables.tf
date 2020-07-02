variable "cluster_data" {
  type = object({
    id      = string
    name    = string
    label   = string
    account = string
    region  = string
  })
}

variable "openid_provider" {
  type = object({
    arn = string
    url = string
  })
}

variable "root_dir" {
  type = string
}
