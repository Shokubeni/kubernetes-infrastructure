//**********************************************************************
//*                     S3 backend configuration                       *
//**********************************************************************

terragrunt = {
  terraform {
    extra_arguments "formation" {
      optional_var_files = ["${get_tfvars_dir()}/${find_in_parent_folders("parameters.tfvars", "ignore")}"],
      commands = ["${get_terraform_commands_that_need_vars()}"]
      arguments = [
        "-var", "backend_bucket=${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}.${get_env("TF_VAR_STATE_BUCKET", "terraform-state")}",
        "-var", "backend_region=${get_env("TF_VAR_AWS_REGION", "us-east-1")}",
        "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "cluster_operator")}",
        "-var", "provider_region=${get_env("TF_VAR_AWS_REGION", "us-east-1")}",
        "-var", "cluster_label=${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}",
        "-var", "cluster_name=${get_env("TF_VAR_CLUSTER_NAME", "SmartGears")}",
        "-var", "root_dir=${get_tfvars_dir()}/../../..",
      ]
    }
  }

  remote_state {
    backend = "s3"
    config {
      encrypt        = true
      bucket         = "${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}.${get_env("TF_VAR_STATE_BUCKET", "terraform-state")}"
      dynamodb_table = "${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}.${get_env("TF_VAR_DYNAMO_LOCK", "terraform-lock")}"
      profile        = "${get_env("TF_VAR_AWS_PROFILE", "cluster_operator")}"
      region         = "${get_env("TF_VAR_AWS_REGION", "us-east-1")}"
      key            = "${path_relative_to_include()}/terraform.tfstate"
    }
  }
}