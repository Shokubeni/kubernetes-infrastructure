//**********************************************************************
//*                     S3 backend configuration                       *
//**********************************************************************

terragrunt = {
  terraform {
    extra_arguments "formation" {
      optional_var_files = ["${get_tfvars_dir()}/${find_in_parent_folders("parameters.tfvars", "ignore")}"],
      commands = ["${get_terraform_commands_that_need_vars()}"]
      arguments = [
        "-var", "okta_url=${get_env("TF_VAR_OKTA_URL", "false")}",
        "-var", "grafana_client_id=${get_env("TF_VAR_GRAFANA_CLIENT_ID", "false")}",
        "-var", "grafana_secret=${get_env("TF_VAR_GRAFANA_SECRET", "false")}",
        "-var", "okta_url=${get_env("TF_VAR_OKTA_URL", "false")}",
        "-var", "deployment_type=${get_env("TF_VAR_DEPLOYMENT_TYPE", "development")}",
        "-var", "backend_bucket=${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}.${get_env("TF_VAR_STATE_BUCKET", "terraform-state")}",
        "-var", "backend_region=${get_env("TF_VAR_AWS_REGION", "eu-west-1")}",
        "-var", "admin_role=${get_env("TF_VAR_AWS_ROLE", "false")}",
        "-var", "provider_profile=${get_env("TF_VAR_AWS_PROFILE", "cluster_operator")}",
        "-var", "provider_region=${get_env("TF_VAR_AWS_REGION", "eu-west-1")}",
        "-var", "cluster_label=${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}",
        "-var", "cluster_name=${get_env("TF_VAR_CLUSTER_NAME", "SmartGears")}",
        "-var", "smtp_alerts_user=${get_env("TF_VAR_SMTP_ALERTS_USER", "false")}",
        "-var", "smtp_alerts_pass=${get_env("TF_VAR_SMTP_ALERTS_PASS", "false")}",
        "-var", "smtp_metrics_user=${get_env("TF_VAR_SMTP_METRICS_USER", "false")}",
        "-var", "smtp_metrics_pass=${get_env("TF_VAR_SMTP_METRICS_PASS", "false")}",
        "-var", "smtp_host=${get_env("TF_VAR_SMTP_HOST", "false")}",
        "-var", "smtp_port=${get_env("TF_VAR_SMTP_PORT", "false")}",
        "-var", "slack_channel=${get_env("TF_VAR_SLACK_CHANNEL", "false")}",
        "-var", "slack_hook=${get_env("TF_VAR_SLACK_ALERTS_URL", "false")}",
        "-var", "kube_config=${get_env("TF_VAR_KUBE_CONFIG", "false")}",
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
      region         = "${get_env("TF_VAR_AWS_REGION", "eu-west-1")}"
      key            = "${path_relative_to_include()}/terraform.tfstate"
    }
  }
}