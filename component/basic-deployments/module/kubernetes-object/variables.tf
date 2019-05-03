variable "config_path" {
  type = "string"
  default = "null"
}

variable "file_path" {
  type = "string"
}

variable "variables" {
  type = "map"
  default = {}
}

variable "delay_time" {
  type = "string"
  default = "1s"
}

variable "depends_on" {
  type = "list"
  default = []
}