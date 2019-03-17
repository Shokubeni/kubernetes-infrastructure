output "balancer_data" {
  value = {
    dns = "${aws_elb.balancer.dns_name}"
    id  = "${aws_elb.balancer.name}"
  }
}