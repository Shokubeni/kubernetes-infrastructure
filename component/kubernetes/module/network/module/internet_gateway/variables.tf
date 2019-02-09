variable "use_nat_gateways" {
  type = "string"
}

variable "virtual_cloud_id" {
  type = "string"
}

variable "public_subnets_count" {
  type = "string"
}

variable "public_subnets_ids" {
  type = "list"
}

variable "private_subnets_count" {
  type = "string"
}

variable "private_subnets_ids" {
  type = "list"
}

variable "cluster_config" {
  type = "map"
}

variable "cluster_id" {
  type = "string"
}