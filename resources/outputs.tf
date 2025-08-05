output "get_connect_config_lambda" {
  description = "ARN of the Lambda function for contact flow attributes."
  value       = module.get_connect_config_lambda.lambda_function_arn
}

output "kms_key" {
  description = "ARN of the KMS key used for encryption."
  value       = module.common_aws_kms_key.key_arn
}

output "connect_module" {
  description = "Amazon Connect module outputs."
  value       = module.amazon_connect.contact_flow_modules["ch_voice_mail_module"].contact_flow_module_id
}

output "kinesis_stream_arn" {
  description = "ARN of the Kinesis stream for media streams."
  value       = module.kinesis.kinesis_stream_arn
}

output "collect_extention_number_id" {
  description = "List of phone number IDs to associate."
  value       = module.amazon_connect.phone_number_id["collect_extention_number"]
}