output "templates_ids" {
  value = "${aws_launch_template.default.*.id}"
}