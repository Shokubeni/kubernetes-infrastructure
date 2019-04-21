terragrunt = {
  terraform {
    source = "../../../component/kubernetes-cluster"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}