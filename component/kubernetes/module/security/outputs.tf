output "master_node" {
  value = {
    group_id    = "${module.security_group.master_group_id}"
    role_id     = "${module.instance_role.master_role_id}"
    role_arn    = "${module.instance_role.master_role_arn}"
    private_key = "${module.tls_key_pair.master_private_key}"
    public_key  = "${module.tls_key_pair.master_public_key}"
    key_id      = "${module.tls_key_pair.master_key_id}"
  }
}

output "worker_node" {
  value = {
    group_id    = "${module.security_group.worker_group_id}"
    role_id     = "${module.instance_role.worker_role_id}"
    role_arn    = "${module.instance_role.worker_role_arn}"
    private_key = "${module.tls_key_pair.worker_private_key}"
    public_key  = "${module.tls_key_pair.worker_public_key}"
    key_id      = "${module.tls_key_pair.worker_key_id}"
  }
}

output "master_lifecycle" {
  value = {
    id  = "${module.lambda_role.master_lifecycle_id}"
    arn = "${module.lambda_role.master_lifecycle_arn}"
  }
}

output "worker_lifecycle" {
  value = {
    id  = "${module.lambda_role.worker_lifecycle_id}"
    arn = "${module.lambda_role.worker_lifecycle_arn}"
  }
}

output "cloudwatch_event" {
  value = {
    id  = "${module.lambda_role.cloudwatch_event_id}"
    arn = "${module.lambda_role.cloudwatch_event_arn}"
  }
}

output "master_publish" {
  value = {
    id  = "${module.publish_role.master_publish_id}"
    arn = "${module.publish_role.master_publish_arn}"
  }
}

output "worker_publish" {
  value = {
    id  = "${module.publish_role.worker_publish_id}"
    arn = "${module.publish_role.worker_publish_arn}"
  }
}

output "balancer" {
  value = {
    group_id = "${module.security_group.balancer_group_id}"
  }
}