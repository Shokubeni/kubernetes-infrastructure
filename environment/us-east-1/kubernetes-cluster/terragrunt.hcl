terraform {
  source = "../../../component/kubernetes-cluster"

  extra_arguments "formation" {
    optional_var_files = ["${get_terragrunt_dir()}/${find_in_parent_folders("parameters.tfvars", "ignore")}"]
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "cluster_operator")}",
      "-var", "cluster_label=${get_env("TF_VAR_CLUSTER_LABEL", "kubernetes")}",
      "-var", "cluster_name=${get_env("TF_VAR_CLUSTER_NAME", "Kubernetes")}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../..",
      "-var", "provider_region=us-east-1",
    ]
  }
}

include {
  path = find_in_parent_folders()
}
