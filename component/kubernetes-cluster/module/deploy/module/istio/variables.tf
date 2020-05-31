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