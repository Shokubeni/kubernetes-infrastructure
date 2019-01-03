variable "provider_config" {
  type = "map"
}

variable "cluster_config" {
  type = "map"
}

variable "virtual_cloud_cidr" {
  type = "string"
}

variable "private_subnets" {
  type = "map"
}

variable "public_subnets" {
  type = "map"
}

variable "master_node_instance" {
  type = "map"
}

variable "master_root_volume" {
  type = "map"
}

variable "worker_node_instance" {
  type = "map"
}

variable "worker_root_volume" {
  type = "map"
}