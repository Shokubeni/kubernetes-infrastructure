output "subnets_ids" {
  value = "${aws_subnet.public.*.id}"
}