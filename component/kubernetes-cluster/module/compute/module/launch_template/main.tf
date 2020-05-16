locals {
  shutdown_behavior     = var.node_config.instance.shutdown_behavior
  disable_termination   = var.node_config.instance.disable_termination
  ebs_optimized         = var.node_config.instance.ebs_optimized
  cpu_credits           = var.node_config.instance.cpu_credits
  monitoring            = var.node_config.instance.monitoring
  delete_on_termination = var.node_config.volume.delete_on_termination
  volume_type           = var.node_config.volume.volume_type
  volume_size           = var.node_config.volume.volume_size
  iops                  = var.node_config.volume.iops
  role_postfix          = contains(var.cluster_role, "controlplane") ? "master" : "worker"
  role_name             = contains(var.cluster_role, "controlplane") ? "Master" : "Worker"
}

locals {
  zone_image = {
    us-east-1      = "ami-04b9e92b5572fa0d1"
    us-east-2      = "ami-0d5d9d301c853a04a"
    us-west-1      = "ami-0dd655843c87b6930"
    us-west-2      = "ami-06d51e91cea0dac8d"
    ca-central-1   = "ami-0d0eaed20348a3389"
    eu-central-1   = "ami-0cc0a36f626a4fdf5"
    eu-west-1      = "ami-02df9ea15c1778c9c"
    eu-west-2      = "ami-0be057a22c63962cb"
    eu-west-3      = "ami-087855b6c8b59a9e4"
    eu-north-1     = "ami-1dab2163"
    ap-east-1      = "ami-59780228"
    ap-south-1     = "ami-0123b531fc646552f"
    ap-northeast-2 = "ami-00379ec40a3e30f87"
    ap-southeast-1 = "ami-061eb2b23f9f8839c"
    ap-southeast-2 = "ami-00a54827eb7ffcd3c"
    ap-northeast-1 = "ami-0cd744adeca97abb1"
    sa-east-1      = "ami-02c8813f1ea04d4ab"
    me-south-1     = "ami-01011404880c390bf"
  }
}

resource "aws_iam_instance_profile" "launch" {
  name = "${var.cluster_config.label}-${local.role_postfix}_${var.cluster_config.id}."
  role = var.node_role_id
}

resource "aws_launch_template" "launch" {
  name                                 = "${var.cluster_config.label}-${local.role_postfix}_${var.cluster_config.id}"
  image_id                             = local.zone_image[var.cluster_config.region]
  instance_type                        = var.node_config.instance.instance_types[0]
  ebs_optimized                        = local.ebs_optimized
  instance_initiated_shutdown_behavior = local.shutdown_behavior
  disable_api_termination              = local.disable_termination
  key_name                             = var.key_pair_id
  description                          = "${local.role_postfix} nodes launch"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = local.delete_on_termination
      volume_type           = local.volume_type
      volume_size           = local.volume_size
      iops                  = local.iops
      encrypted             = "true"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.launch.id
  }

  credit_specification {
    cpu_credits = local.cpu_credits
  }

  monitoring {
    enabled = local.monitoring
  }

  network_interfaces {
    security_groups             = [var.security_group_id]
    associate_public_ip_address = "false"
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "volume"
    tags          = {
      "Name" = "${var.cluster_config.name} ${local.role_name} Node"
      "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = {
      "Name" = "${var.cluster_config.name} ${local.role_name} Node",
      "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
    }
  }

  tags = {
    "Name" = "${var.cluster_config.name} ${local.role_name} Template",
    "kubernetes.io/cluster/${var.cluster_config.id}" = "owned"
  }
}
