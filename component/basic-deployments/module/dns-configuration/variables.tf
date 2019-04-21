variable "balancer_zone" {
  type = "string"
}

variable "balancer_dns" {
  type = "string"
}

variable "provider_profile" {
  type = "string"
}

variable "provider_region" {
  type = "string"
}

variable "domain_config" {
  type = "map"
}

variable "is_main_cluster" {
  type = "string"
}