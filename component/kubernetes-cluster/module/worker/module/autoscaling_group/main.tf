resource "aws_autoscaling_group" "autoscaling" {
  count               = length(var.worker_configs)
  name                = "${var.cluster_data.label}-${var.worker_configs[count.index].instance.node_group_label}_${var.cluster_data.id}"
  desired_capacity    = var.worker_configs[count.index].instance.desired_capacity
  max_size            = var.worker_configs[count.index].instance.max_size
  min_size            = var.worker_configs[count.index].instance.min_size
  vpc_zone_identifier = var.network_data.private_subnet_ids
  suspended_processes = ["AZRebalance"]
  force_delete        = false

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = var.template_ids[count.index]
        version = "$Latest"
      }

      dynamic "override" {
        for_each = var.worker_configs[count.index].instance.instance_types

        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_percentage_above_base_capacity = var.worker_configs[count.index].instance.on_demand_capasity
      spot_max_price = var.worker_configs[count.index].instance.max_price
    }
  }

  tags = [
    {
      key   = "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}"
      value = "owned"
      propagate_at_launch = false
    },
    {
      key   = "kubernetes.io/cluster/autoscaler"
      value = "enabled"
      propagate_at_launch = false
    }
  ]

  lifecycle {
    ignore_changes = all
  }
}
