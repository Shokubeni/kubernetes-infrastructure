variable "cluster_role" {
  type = "list"
}

variable "load_balancer_dns" {
  type = "string"
}

variable "secure_bucket_name" {
  type = "string"
}

variable "lambda_role_arn" {
  type = "string"
}

variable "system_comands" {
  type = "map"
}

variable "cluster_config" {
  type = "map"
}

variable "cluster_id" {
  type = "string"
}