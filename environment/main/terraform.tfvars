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
        "-var", "backend_region=${get_env("TF_VAR_AWS_REGION", "eu-west-1")}",
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
        "-var", "slack_hook=${get_env("TF_VAR_SLACK_ALERTS_URL", "false")}",
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

TF_VAR_AWS_REGION=us-east-1;TF_VAR_AWS_PROFILE=cluster_operator;TF_VAR_CLUSTER_NAME=SmartGears;TF_VAR_CLUSTER_LABEL=smart-gears;TF_VAR_STATE_BUCKET=main-cluster-state;TF_VAR_DYNAMO_LOCK=main-cluster-lock;TF_VAR_SMTP_HOST=email-smtp.us-east-1.amazonaws.com;TF_VAR_SMTP_PORT=587;TF_VAR_SMTP_METRICS_USER=AKIARYL3UTWGC6CQ6ZAL;TF_VAR_SMTP_METRICS_PASS=BBh36yYz5Tp04NX3LxtQXJRU38+Wu/uyNtm7P1mXRmVS;TF_VAR_SMTP_ALERTS_USER=AKIARYL3UTWGA54ZYKEJ;TF_VAR_SMTP_ALERTS_PASS=BGFPMmukP4EsykqJoUJ6Ip1X9g6tucEoYQzvJBc87tmn