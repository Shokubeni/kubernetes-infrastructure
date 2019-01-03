variable "security_group_id" {
  type = "string"
}

variable "iam_role_id" {
  type = "string"
}

variable "node_instance" {
  type = "map"
}

variable "root_volume" {
  type = "map"
}

variable "key_name" {
  type = "string"
}

variable "subnets_cidrs" {
  type = "list"
}

variable "subnets_zones" {
  type = "list"
}

variable "subnets_ids" {
  type = "list"
}

variable "cluster_config" {
  type = "map"
}

variable "tempate_postfix" {
  type = "string"
}