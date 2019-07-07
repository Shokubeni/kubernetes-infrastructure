//**********************************************************************
//*                               Nodes                                *
//**********************************************************************
master_node_config = {
  instance = {
    instance_types        = ["t3a.large", "t3.large", "t2.large"]
    shutdown_behavior     = "terminate"
    cpu_credits           = "standard"
    disable_termination   = false
    ebs_optimized         = false
    monitoring            = false
    max_price             = 0.08
    min_size              = 1
    max_size              = 3
    on_demand_capasity    = 0
    desired_capacity      = 2
  }

  volume = {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 30
  }
}

worker_node_config = {
  instance = {
    instance_types        = ["t3a.xlarge", "t3.xlarge", "t2.xlarge"]
    shutdown_behavior     = "terminate"
    cpu_credits           = "standard"
    disable_termination   = false
    ebs_optimized         = false
    monitoring            = false
    max_price             = 0.08
    min_size              = 1
    max_size              = 5
    on_demand_capasity    = 0
    desired_capacity      = 2
  }

  volume = {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 30
  }
}

//**********************************************************************
//*                              Network                               *
//**********************************************************************
network_config = {
  virtual_cloud_cidr = "172.16.0.0/16"
  nat_instance_type  = "t3a.micro"
  is_main_cluster    = true

  private_subnets    = {
    "172.16.0.0/20"  = "us-east-1b"
    "172.16.16.0/20" = "us-east-1c"
  }

  public_subnets     = {
    "172.16.32.0/20" = "us-east-1b"
    "172.16.48.0/20" = "us-east-1c"
  }

  domain_info        = {
    hosted_zone = "Z1IMWHN7BIT6US"
    domain_name = "smart-gears.io"
  }
}