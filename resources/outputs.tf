output "get_connect_config_lambda" {
  description = "ARN of the Lambda function for contact flow attributes."
  value       = module.get_connect_config_lambda.lambda_function_arn
}

output "kms_key" {
  description = "ARN of the KMS key used for encryption."
  value       = module.common_aws_kms_key.key_arn
}


output "kinesis_stream_arn" {
  description = "ARN of the Kinesis stream for media streams."
  value       = module.kinesis.kinesis_stream_arn
}

