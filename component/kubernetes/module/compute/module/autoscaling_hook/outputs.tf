output "lambda_arn" {
  value = "${aws_lambda_function.lifecycle.arn}"
}

output "topic_arn" {
  value = "${aws_sns_topic.lifecycle.arn}"
}