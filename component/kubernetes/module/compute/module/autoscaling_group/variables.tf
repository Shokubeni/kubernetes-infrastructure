variable "groups_count" {
  type = "string"
}

variable "autoscaling_id" {
  type = "string"
}

variable "templates_ids" {
  type = "list"
}

variable "node_instance" {
  type = "map"
}

variable "cluster_config" {
  type = "map"
}

variable "group_postfix" {
  type = "string"
}