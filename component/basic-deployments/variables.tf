variable "provider_profile" {
  type = "string"
}

variable "provider_region" {
  type = "string"
}

variable "backend_bucket" {
  type = "string"
}

variable "backend_region" {
  type = "string"
}

variable "domain_config" {
  type = "map"
}

variable "is_main_cluster" {
  type = "string"
}