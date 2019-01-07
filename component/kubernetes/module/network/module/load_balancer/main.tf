resource "aws_elb" "rancher_elb" {
  name                      = "${var.cluster_config["label"]}-balancer.${var.cluster_id}"
  subnets                   = "${var.subnets_ids}"
  cross_zone_load_balancing = true
  internal                  = false

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
}