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

variable "control_plane" {
  type = object({
    authority = string
    endpont   = string
    config    = string
    id        = string
  })
}

variable "root_dir" {
  type = string
}
