variable "network_data" {
  type = object({
    internet_gateway_id = string
    private_subnet_ids  = list(string)
    public_subnet_ids   = list(string)
    virtual_cloud_id    = string
  })
}

variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    vpn_clients_cidr   = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)
    tcp_services       = list(object({
      namespace = string
      workload  = string
      port      = number
    }))
    udp_services       = list(object({
      namespace = string
      workload  = string
      port      = number
    }))
    domain_info        = object({
      private_zone = string
      public_zone  = string
      domain_name  = string
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

variable "backup_bucket" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
  })
}

variable "secure_bucket" {
  type = object({
    id     = string
    arn    = string
    name   = string
    region = string
  })
}

variable "master_queue" {
  type = object({
    id   = string
    arn  = string
    name = string
  })
}

variable "worker_queue" {
  type = object({
    id   = string
    arn  = string
    name = string
  })
}
