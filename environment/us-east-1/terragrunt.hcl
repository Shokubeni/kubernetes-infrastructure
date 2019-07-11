remote_state {
  backend = "s3"
  config = {
    dynamodb_table = "${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}.${get_env("TF_VAR_DYNAMO_LOCK", "terraform-lock")}"
    bucket         = "${get_env("TF_VAR_CLUSTER_LABEL", "smart-gears")}.${get_env("TF_VAR_STATE_BUCKET", "terraform-state")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    profile        = get_env("TF_VAR_AWS_PROFILE", "cluster_operator")
    region         = get_env("TF_VAR_AWS_REGION", "eu-west-1")
    encrypt        = true
  }
}