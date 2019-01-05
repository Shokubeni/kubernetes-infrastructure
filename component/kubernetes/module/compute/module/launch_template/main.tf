resource "aws_iam_instance_profile" "default" {
  name = "${var.cluster_config["label"]}-${var.template_postfix}-${substr(sha512(timestamp()), 0, 5)}"
  role = "${var.iam_role_id}"
}

resource "aws_launch_template" "default" {
  count                                = "${length(var.subnets_cidrs)}"
  name                                 = "${var.cluster_config["label"]}-${var.template_postfix}-${substr(sha512(timestamp()), 0, 5)}"
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
      max_price                      = "${var.node_instance["max_price"]}"
      spot_instance_type             = "one-time"
    }
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = "${var.root_volume["delete_on_termination"]}"
      volume_type           = "${var.root_volume["volume_type"]}"
      volume_size           = "${var.root_volume["volume_size"]}"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = ["${var.security_group_id}"]
    subnet_id                   = "${element(var.subnets_ids, count.index)}"
  }

  credit_specification {
    cpu_credits = "${var.node_instance["cpu_credits"]}"
  }

  iam_instance_profile {
    name = "${aws_iam_instance_profile.default.id}"
  }

  monitoring {
    enabled = "${var.node_instance["monitoring"]}"
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