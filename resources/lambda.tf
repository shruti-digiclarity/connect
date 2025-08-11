module "voice_mail_packager_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-voice-mail-packager-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = "ch_voice_mail_packager.lambda_handler"
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = "../lambda_function/ch-lmda-voice-mail-packager.zip"
  layers                  = []
  timeout                 = 900
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["voice_mail_packager_lambda_policy"]
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
  local_existing_package  = "../lambda_function/ch-lmda-kvs-to-s3.zip"
  layers                  = []
  timeout                 = 900
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["kvs_to_s3_lambda_policy"]
  environment_variables = {
    s3_recordings_bucket = "${var.company_prefix}-s3-voice-mail-recording-${local.region_prefix}-${var.env}"
  }
  event_source_mapping = {
    kinesis = {
      event_source_arn                   = module.kinesis.kinesis_stream_arn
      starting_position                  = "LATEST"
      batch_size                         = 100
      maximum_batching_window_in_seconds = null
      maximum_retry_attempts             = -1
      maximum_record_age_in_seconds      = -1
      bisect_batch_on_function_error     = false
    }
  }

  tags = local.lambda_default_configurations.tags
}

module "voice_mail_presigner_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-voice-mail-presigner-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = "ch_voice_mail_presigner.lambda_handler"
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = "../lambda_function/ch-lmda-voice-mail-presigner.zip"
  layers                  = []
  timeout                 = 900
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["voice_mail_presigner_lambda_policy"]
  tags                    = local.lambda_default_configurations.tags
}

module "voice_mail_transcriber_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-voice-mail-transcriber-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = "ch_voice_mail_transcriber.lambda_handler"
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = "../lambda_function/ch-lmda-voice-mail-transcriber.zip"
  layers                  = []
  timeout                 = 3
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["voice_mail_transcriber_lambda_policy"]
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
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["get_connect_config_lambda_policy"]
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
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["check_holiday_and_hoop_lambda_policy"]
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

module "load_config_data_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-load-config-data-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = local.lambda_default_configurations.handler
  runtime                 = local.lambda_default_configurations.runtime
  local_existing_package  = local.lambda_default_configurations.package
  layers                  = []
  timeout                 = 3
  memory_size             = local.lambda_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["load_config_data_lambda_policy"]
  environment_variables = {
    CONFIG_TABLE_NAME = "${var.company_prefix}-dydb-connect-config-${local.region_prefix}-${var.env}"
    ENV               = var.env
  }
  tags = local.lambda_default_configurations.tags
}

module "lead_generation_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-lead-generation-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = local.lambda_node_default_configurations.handler
  runtime                 = local.lambda_node_default_configurations.runtime
  local_existing_package  = local.lambda_node_default_configurations.package
  layers                  = []
  timeout                 = 3
  memory_size             = local.lambda_node_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_node_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["lead_generation_lambda_policy"]
  environment_variables = {
    ENV               = var.env
  }
  tags = local.lambda_node_default_configurations.tags
}

module "campaign_attribution_lambda" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=master"
  name                    = format("%s-lmda-campaign-attribution-%s-%s", var.company_prefix, local.region_prefix, var.env)
  handler                 = local.lambda_node_default_configurations.handler
  runtime                 = local.lambda_node_default_configurations.runtime
  local_existing_package  = local.lambda_node_default_configurations.package
  layers                  = []
  timeout                 = 3
  memory_size             = local.lambda_node_default_configurations.memory_size
  ignore_source_code_hash = local.lambda_node_default_configurations.ignore_source_code_hash
  attach                  = { policy_jsons = true }
  iam_configuration       = local.lambda_iam_configurations["campaign_attribution_lambda_policy"]
  environment_variables = {
    ENV               = var.env
  }
  tags = local.lambda_node_default_configurations.tags
}

