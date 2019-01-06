output "balancer_id" {
  value = "${aws_elb.rancher_elb.id}"
}

output "balancer_dns" {
  value = "${aws_elb.rancher_elb.dns_name}"
}