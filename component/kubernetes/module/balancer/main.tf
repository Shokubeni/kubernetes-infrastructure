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

  listener {
    lb_port            = 443
    lb_protocol        = "tcp"
    instance_port      = 443
    instance_protocol  = "tcp"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "tcp"
    instance_port     = 80
    instance_protocol = "tcp"
  }

  health_check {
    target              = "TCP:6443"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}