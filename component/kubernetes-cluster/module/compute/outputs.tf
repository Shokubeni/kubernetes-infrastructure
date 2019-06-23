output "autoscaling" {
  value = {
    group_id = module.autoscaling_group.group_id
  }
}

output "launch" {
  value = {
    template_id = module.launch_tempate.template_id
  }
}