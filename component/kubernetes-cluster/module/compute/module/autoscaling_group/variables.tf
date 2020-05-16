variable "node_config" {
  type = object({
    instance = object({
      instance_types        = list(string)
      shutdown_behavior     = string
      cpu_credits           = string
      disable_termination   = bool
      ebs_optimized         = bool
      monitoring            = bool
      max_price             = number
      min_size              = number
      max_size              = number
      on_demand_capasity    = number
      desired_capacity      = number
    })
    volume = object({
      delete_on_termination = bool
      volume_type           = string
      volume_size           = number
      iops                  = number
    })
  })
}

variable "cluster_config" {
  type = object({
    id         = string
    name       = string
    label      = string
    account    = string
    region     = string
    prod       = bool
  })
}

variable "cluster_role" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "load_balancer_id" {
  type = string
}

variable "publish_queue_arn" {
  type = string
}

variable "publish_role_arn" {
  type = string
}

variable "launch_template_id" {
  type = string
}

variable "function_name" {
  type = string
}
