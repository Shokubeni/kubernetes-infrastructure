variable "cluster_role" {
  type = "list"
}

variable "security_group_id" {
  type = "string"
}

variable "node_role_id" {
  type = "string"
}

variable "key_pair_id" {
  type = "string"
}

variable "launch_config" {
  type = "map"
}

variable "volume_config" {
  type = "map"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "cluster_config" {
  type = "map"
}