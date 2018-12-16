output "subnets_ids" {
  value = "${aws_subnet.private.*.id}"
}