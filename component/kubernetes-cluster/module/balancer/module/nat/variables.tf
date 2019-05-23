variable "nat_instance_type" {
  type = "string"
}

variable "nat_security" {
  type = "map"
}

variable "cluster_config" {
  type = "map"
}

variable "private_subnets" {
  type = "map"
}

variable "public_subnets" {
  type = "map"
}

variable "network_data" {
  type = "map"
}