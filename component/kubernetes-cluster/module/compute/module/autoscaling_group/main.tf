locals {
  capasity         = var.node_config.instance.on_demand_capasity
  desired_capacity = var.node_config.instance.desired_capacity
  max_size         = var.node_config.instance.max_size
  min_size         = var.node_config.instance.min_size
  check_type       = contains(var.cluster_role, "controlplane") ? "ELB" : "EC2"
  role_postfix     = contains(var.cluster_role, "controlplane") ? "master" : "worker"
  load_balancer    = contains(var.cluster_role, "controlplane") ? var.load_balancer_id : ""
}

resource "aws_autoscaling_group" "autoscaling" {
  name                      = "${var.cluster_config.label}-${local.role_postfix}_${var.cluster_config.id}"
  max_size                  = local.max_size
  min_size                  = local.min_size
  vpc_zone_identifier       = var.private_subnet_ids
  load_balancers            = [local.load_balancer]
  health_check_type         = local.check_type
  force_delete              = false
  desired_capacity          = 1

  initial_lifecycle_hook {
    name                    = "${var.cluster_config.label}-${local.role_postfix}_${var.cluster_config.id}"
    default_result          = "ABANDON"
    heartbeat_timeout       = 600
    lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
    notification_target_arn = var.publish_queue_arn
    role_arn                = var.publish_role_arn
  }

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = var.launch_template_id
        version = "$Latest"

      }

      dynamic "override" {
        for_each = var.node_config.instance.instance_types

        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_percentage_above_base_capacity = local.capasity
      spot_max_price = var.node_config.instance.max_price
    }
  }

  tags = [
    {
      "key"   = "kubernetes.io/cluster/${var.cluster_config.id}"
      "value" = "owned"
      "propagate_at_launch" = false
    },
    {
      "key"   = "kubernetes.io/cluster/autoscaler"
      "value" = "enabled"
      "propagate_at_launch" = false
    }
  ]

  lifecycle {
    ignore_changes = ["*"]
  }
}

resource "aws_autoscaling_schedule" "autoscaling" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling.name
  scheduled_action_name  = "after-group-init"
  desired_capacity       = local.desired_capacity
  max_size               = local.max_size
  min_size               = local.min_size
  start_time             = timeadd(timestamp(), "30s")
}

resource "aws_lambda_event_source_mapping" "lifecycle" {
  event_source_arn  = var.publish_queue_arn
  function_name     = var.function_name
  enabled           = true
  batch_size        = 1
}

resource "aws_lambda_permission" "lifecycle" {
  source_arn     = var.publish_queue_arn
  function_name  = var.function_name
  action         = "lambda:InvokeFunction"
  principal      = "sqs.amazonaws.com"
}