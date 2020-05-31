variable "cluster_data" {
  type = object({
    id      = string
    name    = string
    label   = string
    account = string
    region  = string
  })
}

variable "bucket_data" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
  })
}
