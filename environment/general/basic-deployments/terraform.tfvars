terragrunt = {
  terraform {
    source = "../../../component/basic-deployments"
  }

  dependencies {
    paths = ["../kubernetes-cluster"]
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}