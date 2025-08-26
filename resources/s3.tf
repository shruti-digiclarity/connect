# Existing S3 bucket configurations (unchanged)
module "s3_call_recording" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.1"
  bucket_name              = format("%s-s3-call-recording-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  encryption_configuration = {
    rule = [
      {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = "aws:kms"
          kms_master_key_id = module.common_aws_kms_key.key_arn
        }
        bucket_key_enabled = true # Optional: improves performance and reduces costs
      }
    ]
  }
  tags = local.tags
}

module "s3_schedueled_report" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.1"
  bucket_name              = format("%s-s3-schedule-reports-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  encryption_configuration = {
    rule = [
      {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = "aws:kms"
          kms_master_key_id = module.common_aws_kms_key.key_arn
        }
        bucket_key_enabled = true # Optional: improves performance and reduces costs
      }
    ]
  }
  tags = local.tags
}

module "s3_voice_mail_recording" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.1"
  bucket_name              = format("%s-s3-voice-mail-recording-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  encryption_configuration = {
    rule = [
      {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = "aws:kms"
          kms_master_key_id = module.common_aws_kms_key.key_arn
        }
        bucket_key_enabled = true # Optional: improves performance and reduces costs
      }
    ]
  }
  lambda_trigger = true
  notification_configuration = {
    lambda = {
      voice_mail_transcriber = {
        function_name = module.voice_mail_transcriber_lambda.lambda_function_name
        function_arn  = module.voice_mail_transcriber_lambda.lambda_function_arn
        events        = ["s3:ObjectCreated:Put"]
      }
    }
  }
  versioning_configuration = { status = true, mfa_delete = false }
  tags                     = local.tags
}

module "s3_voice_mail_transcript" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.1"
  bucket_name              = format("%s-s3-voice-mail-transcript-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  tags                     = local.tags
  encryption_configuration = {
    rule = [
      {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = "aws:kms"
          kms_master_key_id = module.common_aws_kms_key.key_arn
        }
        bucket_key_enabled = true # Optional: improves performance and reduces costs
      }
    ]
  }
  lambda_trigger = true
  notification_configuration = {
    lambda = {
      voice_mail_transcriber = {
        function_name = module.voice_mail_packager_lambda.lambda_function_name
        function_arn  = module.voice_mail_packager_lambda.lambda_function_arn
        events        = ["s3:ObjectCreated:Put"]
      }
    }
  }
}

# New S3 bucket for connect
module "s3_connect" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.1"
  bucket_name              = format("%s-s3-connect-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  encryption_configuration = {
    rule = [
      {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = "aws:kms"
          kms_master_key_id = module.common_aws_kms_key.key_arn
        }
        bucket_key_enabled = true
      }
    ]
  }
  lifecycle_rules = [
    {
      id     = "connect-lifecycle"
      status = "Enabled"
      transition = [
        {
          days          = 365 # 1 year
          storage_class = "GLACIER"
        }
      ]
      expiration = {
        days = 4020 # 11 years
      }
    }
  ]
  tags = local.tags
}