output "control_plane" {
  value = {
    group_id  = module.security_group.control_plane_group_id
    group_arn = module.security_group.control_plane_group_arn
    role_id   = module.entity_iam_role.control_plane_role_id
    role_arn  = module.entity_iam_role.control_plane_role_arn
  }
}

output "worker_node" {
  value = {
    group_id  = module.security_group.worker_node_group_id
    group_arn = module.security_group.worker_node_group_arn
    role_id   = module.entity_iam_role.worker_node_role_id
    role_arn  = module.entity_iam_role.worker_node_role_arn
  }
}

output "nat_instance" {
  value = {
    group_id  = module.security_group.nat_instance_group_id
    group_arn = module.security_group.nat_instance_group_arn
  }
}

output "backup_user" {
  value = {
    user_id  = module.entity_iam_user.backup_user_id
    user_arn = module.entity_iam_user.backup_user_arn
  }
}