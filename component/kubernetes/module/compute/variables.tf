variable "cluster_role" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "security_group_id" {
  type = "string"
}

variable "load_balancer_id" {
  type = "string"
  default = ""
}

variable "publish_role_arn" {
  type = "string"
}

variable "lambda_role_arn" {
  type = "string"
}

variable "node_role_id" {
  type = "string"
}

variable "key_pair_id" {
  type = "string"
}

variable "system_comands" {
  type = "map"
}

variable "launch_config" {
  type = "map"
}

variable "volume_config" {
  type = "map"
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