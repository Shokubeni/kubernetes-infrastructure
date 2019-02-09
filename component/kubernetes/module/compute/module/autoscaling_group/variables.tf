variable "cluster_role" {
  type = "list"
}

variable "launch_config" {
  type = "map"
}

variable "subnet_ids" {
  type = "list"
}

variable "load_balancer_id" {
  type = "string"
}

variable "publish_queue_arn" {
  type = "string"
}

variable "publish_role_arn" {
  type = "string"
}

variable "template_id" {
  type = "string"
}

variable "cluster_config" {
  type = "map"
}

variable "cluster_id" {
  type = "string"
}