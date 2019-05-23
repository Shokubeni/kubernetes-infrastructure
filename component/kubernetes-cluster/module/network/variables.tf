variable "virtual_cloud_cidr" {
  type = "string"
}

variable "nat_instance_type" {
  type = "string"
}

variable "private_subnets" {
  type = "map"
}

variable "public_subnets" {
  type = "map"
}

variable "cluster_config" {
  type = "map"
}