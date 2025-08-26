module "firehose_connect" {
  source                      = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-kinesis-firehose-wrapper?ref=v1.0.1"
  name                        = format("%s-firehose-connect-%s-%s", var.company_prefix, local.region_prefix, var.env)
  destination                 = "s3"
  s3_prefix                   = "CTR/"
  append_delimiter_to_record  = true
  s3_kms_key_arn              = module.common_aws_kms_key.key_arn
  enable_s3_encryption        = true
  s3_bucket_arn               = module.s3_connect.bucket_arn
  buffering_size              = 5
  buffering_interval          = 300
  tags                        = local.tags
  depends_on                  = [module.s3_connect]
  input_source                = "kinesis"
  kinesis_source_stream_arn   = module.kinesis.kinesis_stream_arn
  kinesis_source_is_encrypted = true
  kinesis_source_kms_arn      = module.common_aws_kms_key.key_arn
}