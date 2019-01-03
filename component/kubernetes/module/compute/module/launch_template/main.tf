locals {
  unique_hash = "${substr(sha512(timestamp()), 0, 5)}"
}

resource "aws_launch_template" "master" {
  count                                = "${length(var.subnets_cidrs)}"
  name                                 = "${var.cluster_config["label"]}-${var.tempate_postfix}-${local.unique_hash}"
  ebs_optimized                        = "${var.node_instance["ebs_optimized"]}"
  instance_initiated_shutdown_behavior = "${var.node_instance["shutdown_behavior"]}"
  instance_type                        = "${var.node_instance["instance_type"]}"
  disable_api_termination              = "${var.node_instance["disable_termination"]}"
  image_id                             = "${var.node_instance["image_id"]}"
  key_name                             = "${var.key_name}"

  instance_market_options {
    market_type = "${var.node_instance["spot_fleet"] ? "spot" : "ondemand"}"

    spot_options {
      instance_interruption_behavior = "${var.node_instance["shutdown_behavior"]}"
      spot_instance_type             = "${var.node_instance["instance_type"]}"
      max_price                      = "${var.node_instance["max_price"]}"
      valid_until                    = "${timestamp()}"
    }
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = "${var.root_volume["delete_on_termination"]}"
      volume_type           = "${var.root_volume["volume_type"]}"
      volume_size           = "${var.root_volume["volume_size"]}"
      iops                  = "${var.root_volume["iops"]}"
    }
  }

  network_interfaces {
    security_groups = ["${var.security_group_id}"]
    subnet_id       = "${element(var.subnets_ids, count.index)}"
  }

  credit_specification {
    cpu_credits = "${var.node_instance["cpu_credits"]}"
  }

  monitoring {
    enabled = "${var.node_instance["monitoring"]}"
  }

  iam_instance_profile {
    name = "${var.iam_role_id}"
  }

  tag_specifications {
    resource_type = "volume"
    tags          = "${merge(
      map(
        "Name", "${var.cluster_config["name"]} Master Node",
        "Environment", "${terraform.workspace}",
        "kubernetes.io/cluster/${var.cluster_config["label"]}", "owned"
      )
    )}"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = "${merge(
      map(
        "Name", "${var.cluster_config["name"]} Master Node",
        "Environment", "${terraform.workspace}",
        "kubernetes.io/cluster/${var.cluster_config["label"]}", "owned"
      )
    )}"
  }
}