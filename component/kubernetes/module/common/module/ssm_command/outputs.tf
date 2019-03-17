output "node_runtime_install" {
  value = "${aws_ssm_document.node_runtime.name}"
}

output "general_master_init" {
  value = "${aws_ssm_document.general_master.name}"
}

output "stacked_master_init" {
  value = "${aws_ssm_document.stacked_master.name}"
}

output "common_worker_init" {
  value = "${aws_ssm_document.common_worker.name}"
}

output "cluster_etcd_backup" {
  value = "${aws_ssm_document.cluater_backup.name}"
}