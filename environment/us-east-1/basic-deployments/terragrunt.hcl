terraform {
  source = "../../../component/basic-deployments"

  extra_arguments "formation" {
    optional_var_files = ["${get_terragrunt_dir()}/${find_in_parent_folders("parameters.tfvars", "ignore")}"]
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "cluster_operator")}",
      "-var", "provider_region=${get_env("TF_VAR_AWS_REGION", "us-east-1")}",
      "-var", "backend_bucket=${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}.${get_env("TF_VAR_STATE_BUCKET", "terraform-state")}",
      "-var", "backend_region=${get_env("TF_VAR_AWS_REGION", "us-east-1")}",
      "-var", "smtp_alerts_user=${get_env("TF_VAR_SMTP_ALERTS_USER", false)}",
      "-var", "smtp_alerts_pass=${get_env("TF_VAR_SMTP_ALERTS_PASS", false)}",
      "-var", "smtp_metrics_user=${get_env("TF_VAR_SMTP_METRICS_USER", false)}",
      "-var", "smtp_metrics_pass=${get_env("TF_VAR_SMTP_METRICS_PASS", false)}",
      "-var", "smtp_host=${get_env("TF_VAR_SMTP_HOST", false)}",
      "-var", "smtp_port=${get_env("TF_VAR_SMTP_PORT", false)}",
      "-var", "slack_channel=${get_env("TF_VAR_SLACK_CHANNEL", false)}",
      "-var", "slack_hook=${get_env("TF_VAR_SLACK_ALERTS_URL", false)}",
      "-var", "kube_config=${get_env("TF_VAR_KUBE_CONFIG", false)}",
      "-var", "admin_role=${get_env("TF_VAR_AWS_ROLE", false)}",
      "-var", "grafana_client_id=${get_env("TF_VAR_GRAFANA_CLIENT_ID", false)}",
      "-var", "grafana_secret=${get_env("TF_VAR_GRAFANA_SECRET", false)}"
    ]
  }
}

dependencies {
  paths = ["../kubernetes-cluster"]
}

include {
  path = find_in_parent_folders()
}