variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    nat_instance_type  = string
    is_main_cluster    = bool
    private_subnets    = map(string)
    public_subnets     = map(string)
    ssh_kube_service   = string
    domain_info        = object({
      hosted_zone = string
      domain_name = string
    })
  })
}

variable "cluster_config" {
  type = object({
    id         = string
    name       = string
    label      = string
    kubernetes = string
    docker     = string
    account    = string
    region     = string
    type       = string
  })
}

variable "config_path" {
  type = string
}

variable "admin_role" {
  type = string
}
