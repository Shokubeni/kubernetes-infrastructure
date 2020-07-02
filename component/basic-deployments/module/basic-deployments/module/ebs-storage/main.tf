resource "helm_release" "ebs_storage" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/module/ebs-storage/chart"
  namespace = "kube-system"
  name      = "ebs-storage"
}