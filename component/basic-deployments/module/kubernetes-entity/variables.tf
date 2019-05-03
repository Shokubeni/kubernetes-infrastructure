variable "config_path" {
  type = "string"
  default = "false"
}

variable "file_path" {
  type = "string"
}

variable "variables" {
  type = "map"
  default = {}
}

variable "delete_wait" {
  type = "string"
  default = "1s"
}