module "voice_mail_packager_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-voice-mail-packager-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = "ch_voice_mail_packager.lambda_handler"
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = [module.lambda_layer_backend.lambda_layer_arn]
  timeout                 = 900
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = false }
  environment_variables = {
    default_vm_mode        = "email"
    presigner_function_arn = "${var.company_prefix}-lmda-voice-mail-presigner-${local.region_prefix}-${var.env}"
    s3_recordings_bucket   = "${var.company_prefix}-s3-voice-mail-recording-${local.region_prefix}-${var.env}"
    s3_transcripts_bucket  = "${var.company_prefix}-s3-voice-mail-transcript-${local.region_prefix}-${var.env}"
  }
  tags = local.lambda_default_configurations.tags
}

module "kvs_to_s3_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-kvs-to-s3-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = "ch_voice_mail_kvs_to_s3.lambda_handler"
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = [module.lambda_layer_backend.lambda_layer_arn]
  timeout                 = 900
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = false }
  environment_variables = {
    s3_recordings_bucket = "${var.company_prefix}-s3-voice-mail-recording-${local.region_prefix}-${var.env}"
  }
  tags = local.lambda_default_configurations.tags
}

module "voice_mail_presigner_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-voice-mail-presigner-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = "ch_voice_mail_presigner.lambda_handler"
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = [module.lambda_layer_backend.lambda_layer_arn]
  timeout                 = 900
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = false }
  tags                    = local.lambda_default_configurations.tags
}

module "voice_mail_transcriber_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-voice-mail-transcriber-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = "ch_voice_mail_transcriber.lambda_handler"
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = []
  timeout                 = 3
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = false }
  environment_variables = {
    s3_transcripts_bucket = "${var.company_prefix}-s3-voice-mail-transcript-${local.region_prefix}-${var.env}"
  }
  tags = local.lambda_default_configurations.tags
}

module "get_connect_config_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-get-connect-config-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = local.lambda_default_configurations.handler
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = []
  timeout                 = 3
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = false }
  environment_variables = {
    CONFIG_TABLE_NAME = "${var.company_prefix}-dydb-connect-config-${local.region_prefix}-${var.env}"
  }
  tags = local.lambda_default_configurations.tags
}

module "check_holiday_and_hoop_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-check-holiday-and-hoop-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = local.lambda_default_configurations.handler
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = [module.check_holiday_and_hoop_lambda_backend.lambda_layer_arn]
  timeout                 = 3
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = false }
  environment_variables = {
    CONFIG_TABLE_NAME = "${var.company_prefix}-dydb-connect-config-${local.region_prefix}-${var.env}"
  }
  tags = local.lambda_default_configurations.tags
}

module "match_extension_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-match-extension-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = local.lambda_default_configurations.handler
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = []
  timeout                 = 3
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["match_extension_lambda"]
  environment_variables = {
    COMPANY_PREFIX    = var.company_prefix
    CONFIG_TABLE_NAME = "${var.company_prefix}-dydb-connect-config-${local.region_prefix}-${var.env}"
    ENV               = var.env
    REGION            = local.region_prefix
    REGION_PREFIX     = local.region_prefix
  }
  tags = local.lambda_default_configurations.tags
}
