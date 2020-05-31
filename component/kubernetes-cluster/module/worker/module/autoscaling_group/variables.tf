variable "worker_configs" {
  type = list(object({
    instance = object({
      node_group_label    = string
      instance_types      = list(string)
      shutdown_behavior   = string
      cpu_credits         = string
      disable_termination = bool
      ebs_optimized       = bool
      monitoring          = bool
      max_price           = number
      min_size            = number
      max_size            = number
      on_demand_capasity  = number
      desired_capacity    = number
      kubelet_extra_args  = map(list(string))
    })

    volume = object({
      termination = bool
      volume_type = string
      volume_size = number
      iops        = number
    })
  }))
}

variable "network_data" {
  type = object({
    internet_gateway_id = string
    private_subnet_ids  = list(string)
    public_subnet_ids   = list(string)
    virtual_cloud_id    = string
  })
}

variable "cluster_data" {
  type = object({
    id      = string
    name    = string
    label   = string
    account = string
    region  = string
  })
}

variable "template_ids" {
  type = list(string)
}