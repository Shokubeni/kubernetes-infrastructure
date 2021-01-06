terraform {
  source = "../../../component/istio-service-mesh"

  extra_arguments "formation" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/${path_relative_from_include()}/parameters.tfvars",
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "k8s_operations")}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../..",
      "-var", "backend_bucket=kubernetes-cluster.terraform-state",
      "-var", "backend_region=us-east-1",
      "-var", "provider_region=us-east-1",
    ]
  }

  before_hook "before_hook" {
    commands = get_terraform_commands_that_need_vars()
    execute = [
      "terraform",
      "refresh",
      "-var-file=${get_terragrunt_dir()}/${path_relative_from_include()}/parameters.tfvars",
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "k8s_operations")}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../..",
      "-var", "backend_bucket=kubernetes-cluster.terraform-state",
      "-var", "backend_region=us-east-1",
      "-var", "provider_region=us-east-1",
    ]
  }
}

dependencies {
  paths = ["../kubernetes-cluster"]
}

include {
  path = find_in_parent_folders()
}