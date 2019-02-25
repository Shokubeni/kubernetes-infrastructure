output "lambda_arn" {
  value = "${aws_lambda_function.lifecycle.arn}"
}

output "queue_arn" {
  value = "${aws_sqs_queue.lifecycle.arn}"
}