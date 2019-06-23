terraform {
  source = "../../../component/kubernetes-cluster"

  extra_arguments "formation" {
    optional_var_files = ["${get_terragrunt_dir()}/${find_in_parent_folders("parameters.tfvars", "ignore")}"]
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var", "deployment_type=${get_env("TF_VAR_DEPLOYMENT_TYPE", "development")}",
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "cluster_operator")}",
      "-var", "provider_region=${get_env("TF_VAR_AWS_REGION", "us-east-1")}",
      "-var", "cluster_label=${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}",
      "-var", "cluster_name=${get_env("TF_VAR_CLUSTER_NAME", "SmartGears")}",
      "-var", "admin_role=${get_env("TF_VAR_AWS_ROLE", "false")}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../../..",
    ]
  }
}

include {
  path = find_in_parent_folders()
}