locals {
  shutdown_behavior     = "${lookup(var.launch_config, "shutdown_behavior", "terminate")}"
  disable_termination   = "${lookup(var.launch_config, "disable_termination", false)}"
  ebs_optimized         = "${lookup(var.launch_config, "ebs_optimized", false)}"
  cpu_credits           = "${lookup(var.launch_config, "cpu_credits", "standard")}"
  monitoring            = "${lookup(var.launch_config, "monitoring", false)}"
  delete_on_termination = "${lookup(var.volume_config, "delete_on_termination", true)}"
  volume_type           = "${lookup(var.volume_config, "volume_type", "gp2")}"
  volume_size           = "${lookup(var.volume_config, "volume_size", 10)}"
  market_type           = "${
    contains(keys(var.launch_config), "spot_fleet") &&
    var.launch_config["spot_fleet"]
        ? "spot"
        : "ondemand"
  }"
  role_postfix          = "${
    contains(var.cluster_role, "controlplane")
        ? "master"
        : "worker"
  }"
  role_name             = "${
    contains(var.cluster_role, "controlplane")
        ? "Master"
        : "Worker"
  }"
}

locals {
  zone_image = {
    us-east-1      = "ami-0ac019f4fcb7cb7e6"
    us-east-2      = "ami-0f65671a86f061fcd"
    us-west-1      = "ami-063aa838bd7631e0b"
    us-west-2      = "ami-0bbe6b35405ecebdb"
    ca-central-1   = "ami-0427e8367e3770df1"
    eu-central-1   = "ami-0bdf93799014acdc4"
    eu-west-1      = "ami-00035f41c82244dab"
    eu-west-2      = "ami-0b0a60c0a2bd40612"
    eu-west-3      = "ami-08182c55a1c188dee"
    eu-north-1     = "ami-34c14f4a"
    ap-northeast-1 = "ami-07ad4b1c3af1ea214"
    ap-northeast-2 = "ami-06e7b9c5e0c4dd014"
    ap-southeast-1 = "ami-0c5199d385b432989"
    ap-southeast-2 = "ami-07a3bd4944eb120a0"
    ap-south-1     = "ami-0d773a3b7bb2bb1c1"
    sa-east-1      = "ami-03c6239555bb12112"
  }
}

data "aws_region" "defaul" {}

resource "aws_iam_instance_profile" "launch" {
  name = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}."
  role = "${var.node_role_id}"
}

resource "aws_launch_template" "launch" {
  name                                 = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
  image_id                             = "${local.zone_image[data.aws_region.defaul.name]}"
  instance_type                        = "${var.launch_config["instance_type"]}"
  ebs_optimized                        = "${local.ebs_optimized}"
  instance_initiated_shutdown_behavior = "${local.shutdown_behavior}"
  disable_api_termination              = "${local.disable_termination}"
  key_name                             = "${var.key_pair_id}"

  instance_market_options {
    market_type = "${local.market_type}"

    spot_options {
      max_price                      = "${var.launch_config["max_price"]}"
      instance_interruption_behavior = "${local.shutdown_behavior}"
      spot_instance_type             = "one-time"
    }
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = "${local.delete_on_termination}"
      volume_type           = "${local.volume_type}"
      volume_size           = "${local.volume_size}"
    }
  }

  iam_instance_profile {
    name = "${aws_iam_instance_profile.launch.id}"
  }

  credit_specification {
    cpu_credits = "${local.cpu_credits}"
  }

  monitoring {
    enabled = "${local.monitoring}"
  }

  tag_specifications {
    resource_type = "volume"
    tags          = "${merge(
      map(
        "Name", "${var.cluster_config["name"]} ${local.role_name} Node",
        "kubernetes.io/cluster/${var.cluster_id}", "owned"
      )
    )}"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = "${merge(
      map(
        "Name", "${var.cluster_config["name"]} ${local.role_name} Node",
        "kubernetes.io/cluster/${var.cluster_id}", "owned"
      )
    )}"
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} ${local.role_name} Template",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}