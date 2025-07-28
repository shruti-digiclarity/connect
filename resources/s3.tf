module "s3_call_recording" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=master"
  bucket_name              = format("%s-s3-call-recording-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  tags                     = local.tags
}

module "s3_schedueled_report" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=master"
  bucket_name              = format("%s-s3-schedule-reports-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  tags                     = local.tags
}

module "s3_cfn_bucket" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=master"
  bucket_name              = format("%s-s3-cfn-stack-templates-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  tags                     = local.tags
}

module "s3_cfn_objects" {
  source        = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper/s3_object?ref=master"
  for_each      = local.s3_cfn_objects_map
  create_object = true
  bucket        = "${var.company_prefix}-s3-cfn-stack-templates-${local.region_prefix}-${var.env}"
  key           = each.value.key
  file_source   = each.value.file_source
  source_hash   = filesha256(each.value.file_source)
  depends_on    = [module.s3_cfn_bucket]
}

module "s3_voice_mail_recording" {
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=master"
  bucket_name              = format("%s-s3-voice-mail-recording-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  lambda_trigger           = true
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
  source                   = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-s3-bucket-wrapper?ref=master"
  bucket_name              = format("%s-s3-voice-mail-transcript-%s-%s", var.company_prefix, local.region_prefix, var.env)
  acl                      = null
  public_acl_configuration = null
  versioning_configuration = { status = true, mfa_delete = false }
  tags                     = local.tags
  lambda_trigger           = true
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
