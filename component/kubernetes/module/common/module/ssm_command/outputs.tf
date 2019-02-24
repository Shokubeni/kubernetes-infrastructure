output "sustem_commands" {
  value = {
    node_runtime_install = "${aws_ssm_document.node_runtime.name}"
    general_master_init  = "${aws_ssm_document.general_master.name}"
    stacked_master_init  = "${aws_ssm_document.stacked_master.name}"
    common_worker_init   = "${aws_ssm_document.common_worker.name}"
  }
}