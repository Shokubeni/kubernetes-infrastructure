//**********************************************************************
//*                              General                               *
//**********************************************************************
provider_config = {
  profile = "cluster_operator"
  region  = "us-east-1"
}

cluster_config = {
  name  = "Kubernetes"
  label = "kubernetes"
}


//**********************************************************************
//*                              Network                               *
//**********************************************************************
virtual_cloud_cidr = "172.16.0.0/16"
private_subnets = {
  "172.16.0.0/20"  = "us-east-1b"
}
public_subnets = {
  "172.16.16.0/20" = "us-east-1b"
}


//**********************************************************************
//*                               Nodes                                *
//**********************************************************************
master_node_instance = {
  shutdown_behavior     = "terminate"
  instance_type         = "t3.medium"
  image_id              = "ami-66506c1c"
  cpu_credits           = "standard"
  disable_termination   = false
  ebs_optimized         = false
  monitoring            = false
  spot_fleet            = true
  max_price             = 0.05
  min_size              = 1
  max_size              = 3
}

worker_node_instance = {
  shutdown_behavior     = "terminate"
  instance_type         = "r5.large"
  image_id              = "ami-66506c1c"
  cpu_credits           = "standard"
  disable_termination   = false
  ebs_optimized         = false
  monitoring            = false
  spot_fleet            = true
  max_price             = 0.14
  min_size              = 1
  max_size              = 2
}

master_root_volume = {
  delete_on_termination = true
  volume_type           = "gp2"
  volume_size           = 10
  iops                  = 100
}

worker_root_volume = {
  delete_on_termination = true
  volume_type           = "gp2"
  volume_size           = 10
  iops                  = 100
}