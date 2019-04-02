//**********************************************************************
//*                              Network                               *
//**********************************************************************
virtual_cloud_cidr = "172.16.0.0/16"
use_nat_gateways = "true"
private_subnets = {
  "172.16.0.0/20"  = "us-east-1b"
  "172.16.16.0/20" = "us-east-1c"
}
public_subnets = {
  "172.16.32.0/20" = "us-east-1b"
  "172.16.48.0/20" = "us-east-1c"
}

//**********************************************************************
//*                               Nodes                                *
//**********************************************************************
master_launch_config = {
  instance_types        = "t3.large,t2.large"
  shutdown_behavior     = "terminate"
  cpu_credits           = "standard"
  disable_termination   = false
  ebs_optimized         = false
  monitoring            = false
  on_demand_capasity    = 100
  max_price             = 0.05
  min_size              = 1
  max_size              = 3
  desired_capacity      = 2
}

master_volume_config = {
  delete_on_termination = true
  volume_type           = "gp2"
  volume_size           = 10
}

worker_launch_config = {
  instance_types        = "r5.large,r4.large"
  shutdown_behavior     = "terminate"
  cpu_credits           = "standard"
  disable_termination   = false
  ebs_optimized         = false
  monitoring            = false
  on_demand_capasity    = 100
  max_price             = 0.14
  min_size              = 1
  max_size              = 5
  desired_capacity      = 1
}

worker_volume_config = {
  delete_on_termination = true
  volume_type           = "gp2"
  volume_size           = 10
}