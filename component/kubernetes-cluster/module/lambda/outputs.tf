output "master_lifecycle" {
  value = {
    id  = aws_lambda_function.master_lifecycle.id
    arn = aws_lambda_function.master_lifecycle.arn
  }
}

output "worker_lifecycle" {
  value = {
    id  = aws_lambda_function.worker_lifecycle.id
    arn = aws_lambda_function.worker_lifecycle.arn
  }
}

output "cluster_backup" {
  value = {
    id  = aws_lambda_function.cluster_backup.id
    arn = aws_lambda_function.cluster_backup.arn
  }
}

output "renew_token" {
  value = {
    id  = aws_lambda_function.renew_token.id
    arn = aws_lambda_function.renew_token.arn
  }
}