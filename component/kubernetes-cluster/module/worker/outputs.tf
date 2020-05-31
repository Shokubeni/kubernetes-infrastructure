output "autoscaling_groups" {
  value = {
    arns = module.autoscaling_group.*.autoscaling_group_arns
    ids = module.autoscaling_group.*.autoscaling_group_ids
  }
}

output "launch_templates" {
  value = {
    arns = module.launch_tempate.*.launch_template_arns
    ids = module.launch_tempate.*.launch_template_ids
  }
}
