output "connect_instance_id" {
  value = aws_connect_instance.demo.id
}

output "connect_instance_arn" {
  value = aws_connect_instance.demo.arn
}

output "queue_id" {
  value = aws_connect_queue.demo.queue_id
}

output "lambda_arn" {
  value = aws_lambda_function.connect_demo.arn
}