output "system_command" {
  value = {
    node_runtime_install = "${module.ssm_command.node_runtime_install}"
    general_master_init  = "${module.ssm_command.general_master_init}"
    stacked_master_init  = "${module.ssm_command.stacked_master_init}"
    common_worker_init   = "${module.ssm_command.common_worker_init}"
    cluster_etcd_backup  = "${module.ssm_command.cluster_etcd_backup}"
  }
}

output "cluster_config" {
  value = {
    id         = "${module.cluster_initialize.cluster_id}"
    name       = "${module.cluster_initialize.cluster_name}"
    label      = "${module.cluster_initialize.cluster_label}"
    kubernetes = "${module.cluster_initialize.kubernetes_version}"
    docker     = "${module.cluster_initialize.docker_version}"
    account    = "${module.cluster_initialize.account_id}"
    region     = "${module.cluster_initialize.region_name}"
  }
}

output "master_queue" {
  value = {
    id   = "${module.lifecycle_queue.master_queue_id}"
    arn  = "${module.lifecycle_queue.master_queue_arn}"
    name = "${module.lifecycle_queue.master_queue_name}"
  }
}

output "worker_queue" {
  value = {
    id   = "${module.lifecycle_queue.worker_queue_id}"
    arn  = "${module.lifecycle_queue.worker_queue_arn}"
    name = "${module.lifecycle_queue.worker_queue_name}"
  }
}

output "secure_bucket" {
  value = {
    id  = "${module.secure_bucket.bucket_id}"
    arn = "${module.secure_bucket.bucket_arn}"
  }
}