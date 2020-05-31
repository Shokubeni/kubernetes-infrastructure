output "control_plane_group_id" {
  value = aws_security_group.control_plane.id

  depends_on = [
    aws_security_group.control_plane
  ]
}

output "control_plane_group_arn" {
  value = aws_security_group.control_plane.arn

  depends_on = [
    aws_security_group.control_plane
  ]
}

output "worker_node_group_id" {
  value = aws_security_group.worker_node.id

  depends_on = [
    aws_security_group.worker_node
  ]
}

output "worker_node_group_arn" {
  value = aws_security_group.worker_node.arn

  depends_on = [
    aws_security_group.worker_node
  ]
}

output "nat_instance_group_id" {
  value = aws_security_group.nat_instance.id

  depends_on = [
    aws_security_group.nat_instance
  ]
}

output "nat_instance_group_arn" {
  value = aws_security_group.nat_instance.arn

  depends_on = [
    aws_security_group.nat_instance
  ]
}