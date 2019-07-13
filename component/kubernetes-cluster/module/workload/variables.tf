variable "secure_bucket" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
  })
}

variable "backup_bucket" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
  })
}

variable "backup_user" {
  type = object({
    id  = string
    arn = string
  })
}