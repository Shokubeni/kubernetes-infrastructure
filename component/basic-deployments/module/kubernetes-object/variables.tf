variable "config_path" {
  type = string
  default = false
}

variable "file_path" {
  type = string
}

variable "variables" {
  type = map(any)
  default = {}
}

variable "delay_time" {
  type = string
  default = "1s"
}

variable "depends" {
  type = list(string)
  default = []
}
