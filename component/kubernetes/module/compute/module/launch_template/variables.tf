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

variable "subnet_ids" {
  type = "list"
}

variable "is_public_ip" {
  type = "string"
}

variable "cluster_config" {
  type = "map"
}

variable "cluster_id" {
  type = "string"
}