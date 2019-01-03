output "template_ids" {
  value = "${aws_launch_template.master.*.id}"
}