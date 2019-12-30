output "system_command" {
  value = {
    node_runtime_install   = module.ssm_command.node_runtime_install
    general_master_init    = module.ssm_command.general_master_init
    general_master_restore = module.ssm_command.general_master_restore
    stacked_master_init    = module.ssm_command.stacked_master_init
    common_worker_init     = module.ssm_command.common_worker_init
    cluster_etcd_backup    = module.ssm_command.cluster_etcd_backup
    renew_join_token       = module.ssm_command.renew_join_token
  }
}

output "cluster_config" {
  value = {
    id      = module.cluster_initialize.cluster_id
    name    = module.cluster_initialize.cluster_name
    label   = module.cluster_initialize.cluster_label
    account = module.cluster_initialize.account_id
    region  = module.cluster_initialize.region_name
    type    = var.deployment_type
    prod    = var.runtime_config.is_prod_env
  }
}

output "master_queue" {
  value = {
    id   = module.lifecycle_queue.master_queue_id
    arn  = module.lifecycle_queue.master_queue_arn
    name = module.lifecycle_queue.master_queue_name
  }
}

output "worker_queue" {
  value = {
    id   = module.lifecycle_queue.worker_queue_id
    arn  = module.lifecycle_queue.worker_queue_arn
    name = module.lifecycle_queue.worker_queue_name
  }
}

output "backup_bucket" {
  value = {
    id     = module.backup_bucket.bucket_id
    arn    = module.backup_bucket.bucket_arn
    name   = module.backup_bucket.bucket_name
    region = module.backup_bucket.bucket_region
  }
}

output "secure_bucket" {
  value = {
    id     = module.secure_bucket.bucket_id
    arn    = module.secure_bucket.bucket_arn
    name   = module.secure_bucket.bucket_name
    region = module.secure_bucket.bucket_region
  }
}
