resource "aws_elb" "balancer" {
  name               = "${var.cluster_config["label"]}-${var.cluster_id}"
  security_groups    = ["${var.security_group_id}"]
  subnets            = ["${var.public_subnet_ids}"]

  listener {
    lb_port           = 6443
    lb_protocol       = "tcp"
    instance_port     = 6443
    instance_protocol = "tcp"
  }
}