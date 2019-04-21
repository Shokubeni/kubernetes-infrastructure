output "balancer_data" {
  value = {
    zone = "${aws_elb.balancer.zone_id}"
    dns  = "${aws_elb.balancer.dns_name}"
    id   = "${aws_elb.balancer.name}"
  }
}