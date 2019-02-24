output "balancer_dns" {
  value = "${aws_elb.balancer.dns_name}"
}

output "balancer_id" {
  value = "${aws_elb.balancer.name}"
}