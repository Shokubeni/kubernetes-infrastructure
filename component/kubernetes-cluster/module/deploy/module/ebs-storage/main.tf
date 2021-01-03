resource "helm_release" "ebs_storage" {
  chart     = "${var.root_dir}/component/kubernetes-cluster/module/deploy/module/ebs-storage/chart"
  namespace = "kube-system"
  name      = "ebs-storage"

  depends_on = [
    var.cluster_data
  ]
}