remote_state {
  backend = "s3"
  config = {
    key            = "${path_relative_to_include()}/terraform.tfstate"
    profile        = get_env("TF_VAR_AWS_PROFILE", "k8s_operations")
    dynamodb_table = "kubernetes-cluster.terraform-lock"
    bucket         = "kubernetes-cluster.terraform-state"
    region         = "us-east-1"
    encrypt        = true
  }
}
