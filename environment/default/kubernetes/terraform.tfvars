terragrunt = {
  terraform {
    source = "../../../component/kubernetes"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}