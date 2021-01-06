terraform {
  source = "../../../component/basic-deployments"

  extra_arguments "formation" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/${path_relative_from_include()}/parameters.tfvars",
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "k8s_operations")}",
      "-var", "smtp_metrics_user=${get_env("TF_VAR_SMTP_METRICS_USER", false)}",
      "-var", "smtp_metrics_pass=${get_env("TF_VAR_SMTP_METRICS_PASS", false)}",
      "-var", "smtp_host=${get_env("TF_VAR_SMTP_HOST", false)}",
      "-var", "smtp_port=${get_env("TF_VAR_SMTP_PORT", false)}",
      "-var", "slack_channel=${get_env("TF_VAR_SLACK_CHANNEL", false)}",
      "-var", "slack_hook=${get_env("TF_VAR_SLACK_ALERTS_URL", false)}",
      "-var", "grafana_client_id=${get_env("TF_VAR_GRAFANA_CLIENT_ID", false)}",
      "-var", "grafana_secret=${get_env("TF_VAR_GRAFANA_SECRET", false)}",
      "-var", "kiali_client_id=${get_env("TF_VAR_KIALI_CLIENT_ID", false)}",
      "-var", "kiali_secret=${get_env("TF_VAR_KIALI_SECRET", false)}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../..",
      "-var", "backend_bucket=kubernetes-cluster.terraform-state",
      "-var", "provider_region=us-east-1",
      "-var", "backend_region=us-east-1"
    ]
  }

  before_hook "before_hook" {
    commands = get_terraform_commands_that_need_vars()
    execute = [
      "terraform",
      "refresh",
      "-var-file=${get_terragrunt_dir()}/${path_relative_from_include()}/parameters.tfvars",
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "k8s_operations")}",
      "-var", "smtp_metrics_user=${get_env("TF_VAR_SMTP_METRICS_USER", false)}",
      "-var", "smtp_metrics_pass=${get_env("TF_VAR_SMTP_METRICS_PASS", false)}",
      "-var", "smtp_host=${get_env("TF_VAR_SMTP_HOST", false)}",
      "-var", "smtp_port=${get_env("TF_VAR_SMTP_PORT", false)}",
      "-var", "slack_channel=${get_env("TF_VAR_SLACK_CHANNEL", false)}",
      "-var", "slack_hook=${get_env("TF_VAR_SLACK_ALERTS_URL", false)}",
      "-var", "grafana_client_id=${get_env("TF_VAR_GRAFANA_CLIENT_ID", false)}",
      "-var", "grafana_secret=${get_env("TF_VAR_GRAFANA_SECRET", false)}",
      "-var", "kiali_client_id=${get_env("TF_VAR_KIALI_CLIENT_ID", false)}",
      "-var", "kiali_secret=${get_env("TF_VAR_KIALI_SECRET", false)}",
      "-var", "root_dir=${get_terragrunt_dir()}/../../..",
      "-var", "backend_bucket=kubernetes-cluster.terraform-state",
      "-var", "provider_region=us-east-1",
      "-var", "backend_region=us-east-1"
    ]
  }
}

dependencies {
  paths = ["../istio-service-mesh"]
}

include {
  path = find_in_parent_folders()
}