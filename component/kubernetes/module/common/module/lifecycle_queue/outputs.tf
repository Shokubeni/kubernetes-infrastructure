output "master_queue_id" {
  value = "${aws_sqs_queue.master_lifecycle.id}"
}

output "master_queue_arn" {
  value = "${aws_sqs_queue.master_lifecycle.arn}"
}

output "master_queue_name" {
  value = "${aws_sqs_queue.master_lifecycle.name}"
}

output "worker_queue_id" {
  value = "${aws_sqs_queue.worker_lifecycle.id}"
}

output "worker_queue_arn" {
  value = "${aws_sqs_queue.worker_lifecycle.arn}"
}

output "worker_queue_name" {
  value = "${aws_sqs_queue.worker_lifecycle.name}"
}