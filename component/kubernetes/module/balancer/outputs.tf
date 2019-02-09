output "balancer_id" {
  value = "${aws_elb.balancer.name}"
}