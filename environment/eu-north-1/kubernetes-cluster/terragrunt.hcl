terraform {
  source = "../../../component/kubernetes-cluster"

  extra_arguments "formation" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/${path_relative_from_include()}/parameters.tfvars",
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "k8s_operations")}",
      "-var", "cluster_label=${get_env("TF_VAR_CLUSTER_LABEL", "smartgears")}",
      "-var", "cluster_name=${get_env("TF_VAR_CLUSTER_NAME", "SmartGears")}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../..",
      "-var", "provider_region=eu-north-1",
    ]
  }
}

include {
  path = find_in_parent_folders()
}
