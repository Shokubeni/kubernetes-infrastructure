data "aws_ami" "workers" {
  owners = ["602401143452"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.runtime_config.k8s_version}-v*"]
  }
}

data "template_file" "user_data" {
  count    = length(var.worker_configs)
  template = file("${path.module}/templates/userdata.tpl")
  vars = {
    kubelet_extra_args = join(" ", [for arg, value in var.worker_configs[count.index].instance.kubelet_extra_args : "${arg}=${join(",", value)}"])
    cluster_auth       = var.control_plane.authority
    cluster_endpoint   = var.control_plane.endpont
    cluster_name       = var.control_plane.id
  }
}

resource "aws_iam_instance_profile" "workers" {
  count = length(var.worker_configs)
  name  = "${var.cluster_data.label}-${var.worker_configs[count.index].instance.node_group_label}_${var.cluster_data.id}"
  role  = var.worker_node.role_id
}

resource "aws_launch_template" "workers" {
  count                                = length(var.worker_configs)
  name                                 = "${var.cluster_data.label}-${var.worker_configs[count.index].instance.node_group_label}_${var.cluster_data.id}"
  image_id                             = data.aws_ami.workers.id
  instance_type                        = var.worker_configs[count.index].instance.instance_types[0]
  ebs_optimized                        = var.worker_configs[count.index].instance.ebs_optimized
  instance_initiated_shutdown_behavior = var.worker_configs[count.index].instance.shutdown_behavior
  disable_api_termination              = var.worker_configs[count.index].instance.disable_termination
  user_data                            = base64encode(data.template_file.user_data[count.index].rendered)
  description                          = "Worker nodes launch template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = var.worker_configs[count.index].volume.termination
      volume_type           = var.worker_configs[count.index].volume.volume_type
      volume_size           = var.worker_configs[count.index].volume.volume_size
      iops                  = var.worker_configs[count.index].volume.iops
      encrypted             = "true"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.workers[count.index].id
  }

  credit_specification {
    cpu_credits = var.worker_configs[count.index].instance.cpu_credits
  }

  monitoring {
    enabled = var.worker_configs[count.index].instance.monitoring
  }

  network_interfaces {
    security_groups             = [var.worker_node.group_id]
    associate_public_ip_address = "false"
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "volume"
    tags          = {
      "Name" = "${var.cluster_data.name} Worker Node"
      "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "owned"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = {
      "Name" = "${var.cluster_data.name} Worker Node",
      "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "owned"
    }
  }

  tags = {
    "Name" = "${var.cluster_data.name} Worker Template",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "owned"
  }
}
