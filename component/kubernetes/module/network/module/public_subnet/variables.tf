variable "virtual_cloud_id" {
  type = "string"
}

variable "subnets_count" {
  type = "string"
}

variable "subnets_zones" {
  type = "list"
}

variable "subnets_cidrs" {
  type = "list"
}

variable "cluster_config" {
  type = "map"
}

variable "cluster_id" {
  type = "string"
}