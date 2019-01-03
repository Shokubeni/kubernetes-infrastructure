output "gateways_ids" {
  value = "${aws_internet_gateway.internet.*.id}"
}