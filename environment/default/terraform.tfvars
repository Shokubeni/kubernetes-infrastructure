//**********************************************************************
//*                     S3 backend configuration                       *
//**********************************************************************
terragrunt = {
  remote_state {
    backend = "s3"
    config {
      encrypt        = true
      profile        = "cluster_operator"
      bucket         = "smart-gears.terraform-state"
      dynamodb_table = "smart-gears.terraform-locks"
      region         = "us-east-1"
      key            = "${path_relative_to_include()}/terraform.tfstate"
    }
  }

  terraform {
    extra_arguments "formation" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      optional_var_files = [
        "${get_tfvars_dir()}/${find_in_parent_folders("parameters.tfvars", "ignore")}"
      ]
    }
  }
}