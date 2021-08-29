terraform {
  source = "../../..//component/basic-deployments"

  extra_arguments "formation" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/${path_relative_from_include()}/parameters.tfvars",
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "k8s_operations")}",
      "-var", "telegram_admin=${get_env("TF_VAR_TELEGRAM_ADMIN", false)}",
      "-var", "telegram_token=${get_env("TF_VAR_TELEGRAM_TOKEN", false)}",
      "-var", "grafana_client_id=${get_env("TF_VAR_GRAFANA_CLIENT_ID", false)}",
      "-var", "grafana_secret=${get_env("TF_VAR_GRAFANA_SECRET", false)}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../..",
      "-var", "backend_bucket=kubernetes-cluster.terraform-state",
      "-var", "provider_region=eu-north-1",
      "-var", "backend_region=us-east-1",
    ]
  }
}

dependencies {
  paths = ["../istio-service-mesh"]
}

include {
  path = find_in_parent_folders()
}