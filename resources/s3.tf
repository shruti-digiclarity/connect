# Existing S3 bucket configurations (unchanged)
module "s3_call_recording" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.2"
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
        bucket_key_enabled = true
      }
    ]
  }
  replication_configuration = {
    role = module.iam_role.iam_role_arn
    rule = {
      id       = "ReplicateToDestination"
      status   = "Enabled"
      priority = 1

      destination = {
        bucket             = "arn:aws:s3:::${var.s3_destination_bucket_name}"
        account_id         = "${var.s3_destination_account_id}"
        replica_kms_key_id = "arn:aws:kms:${var.s3_destination_region}:${var.s3_destination_account_id}:key/${var.destination_kms_key_id}"
        access_control_translation = {
          owner = "Destination"
        }
      }

      source_selection_criteria = {
        sse_kms_encrypted_objects = {
          status = "Enabled"
        }
      }

      delete_marker_replication = "Disabled"
    }
  }
  lifecycle_rules = local.s3_lifecycle_rules
  tags = local.tags
}
module "s3_schedueled_report" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.2"
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
  lifecycle_rules = local.s3_lifecycle_rules
  tags = local.tags
}

module "s3_voice_mail_recording" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.2"
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
  lifecycle_rules = local.s3_lifecycle_rules
  tags                     = local.tags
}

module "s3_voice_mail_transcript" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.2"
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
  lifecycle_rules = local.s3_lifecycle_rules
}

# New S3 bucket for connect
module "s3_connect" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=v1.0.2"
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