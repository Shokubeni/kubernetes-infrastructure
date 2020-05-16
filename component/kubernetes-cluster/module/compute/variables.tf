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

variable "network_data" {
  type = object({
    internet_gateway_id = string
    private_subnet_ids  = list(string)
    public_subnet_ids   = list(string)
    virtual_cloud_id    = string
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

variable "node_security" {
  type = object({
    group_id    = string
    role_id     = string
    role_arn    = string
    private_key = string
    public_key  = string
    key_id      = string
  })
}

variable "cluster_role" {
  type = list(string)
}

variable "balancer_data" {
  type = object({
    zone = string
    dns  = string
    id   = string
  })
}

variable "lifecycle_queue" {
  type = object({
    id   = string
    arn  = string
    name = string
  })
}

variable "lifecycle_function" {
  type = object({
    id  = string
    arn = string
  })
}

variable "publish_role" {
  type = object({
    id  = string
    arn = string
  })
}
