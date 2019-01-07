variable "virtual_cloud_cidr" {
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

variable "cluster_id" {
  type = "string"
}