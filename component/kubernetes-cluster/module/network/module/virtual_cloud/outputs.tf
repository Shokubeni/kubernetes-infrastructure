output "cloud_id" {
  value = "${aws_vpc.main.id}"
}

output "group_id" {
  value = "${aws_default_security_group.default.id}"
}

output "acl_id" {
  value = "${aws_default_network_acl.default.id}"
}

output "table_id" {
  value = "${aws_default_route_table.default.id}"
}