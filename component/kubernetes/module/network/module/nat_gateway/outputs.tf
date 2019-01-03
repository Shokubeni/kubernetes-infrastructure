output "gateways_ids" {
  value = "${aws_nat_gateway.nat.*.id}"
}