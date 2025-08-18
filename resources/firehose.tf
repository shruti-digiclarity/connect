module "firehose_connect" {
  source                             = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-kinesis-firehose-wrapper?ref=master"
  name                               = format("%s-firehose-connect-%s-%s", var.company_prefix, local.region_prefix, var.env)
  destination                        = "extended_s3"
  s3_bucket_arn                      = module.s3_connect.bucket_arn
  s3_prefix                          = "CTR/"
  buffering_size                     = var.buffering_size
  buffering_interval                 = var.buffering_interval
  enable_s3_encryption               = true
  s3_kms_key_arn                     = module.common_aws_kms_key.key_arn
  enable_sse                         = true
  sse_kms_key_arn                    = module.common_aws_kms_key.key_arn
  sse_kms_key_type                   = "CUSTOMER_MANAGED_CMK"
  create_application_role            = true
  create_application_role_policy     = true
  application_role_service_principal = "connect.amazonaws.com"
  prefix_company                     = var.company_prefix
  prefix_region                      = local.region_prefix
  env                                = var.env
  application                        = var.project
  append_delimiter_to_record         = true
  input_source                       = "kinesis"
  kinesis_source_stream_arn          = module.kinesis.kinesis_stream_arn
  kinesis_source_is_encrypted        = true
  kinesis_source_kms_arn             = module.common_aws_kms_key.key_arn
  tags = merge(local.tags, {
    Name = format("%s-firehose-connect-%s-%s", var.company_prefix, local.region_prefix, var.env)
  })
}