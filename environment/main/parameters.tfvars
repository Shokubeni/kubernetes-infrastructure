//**********************************************************************
//*                              Network                               *
//**********************************************************************
virtual_cloud_cidr = "172.16.0.0/16"
nat_instance_type = "t3.micro"
is_main_cluster = "true"
private_subnets = {
  "172.16.0.0/20"  = "us-east-1b"
  "172.16.16.0/20" = "us-east-1c"
}
public_subnets = {
  "172.16.32.0/20" = "us-east-1b"
  "172.16.48.0/20" = "us-east-1c"
}
domain_config = {
  hosted_zone = "Z1IMWHN7BIT6US"
  domain_name = "smart-gears.io"
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
  on_demand_capasity    = 0
  max_price             = 0.08
  min_size              = 1
  max_size              = 3
  desired_capacity      = 2
}

master_volume_config = {
  delete_on_termination = true
  volume_type           = "gp2"
  volume_size           = 15
}

worker_launch_config = {
  instance_types        = "t3a.xlarge,t3.xlarge"
  shutdown_behavior     = "terminate"
  cpu_credits           = "standard"
  disable_termination   = false
  ebs_optimized         = false
  monitoring            = false
  on_demand_capasity    = 0
  max_price             = 0.10
  min_size              = 1
  max_size              = 5
  desired_capacity      = 1
}

worker_volume_config = {
  delete_on_termination = true
  volume_type           = "gp2"
  volume_size           = 15
}