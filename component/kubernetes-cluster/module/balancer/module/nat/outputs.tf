output "nat_nodes_ids" {
  value = "${aws_instance.nat.*.id}"
}