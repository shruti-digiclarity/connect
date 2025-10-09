module "amazon_connect" {
  source                            = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=v1.0.3"
  region_prefix                     = local.region_prefix
  company_prefix                    = var.company_prefix
  env                               = var.env
  name                              = format("%s-connect-%s-%s", var.company_prefix, local.region_prefix, var.env)
  create_instance                   = true
  instance_identity_management_type = "SAML"
  instance_storage_configs          = local.instance_storage_configs
  multi_party_conference_enabled    = true
  hours_of_operations               = local.hours_of_operations
  queues                            = local.queues
  contact_flows                     = local.contact_flows
  quick_connects                    = local.quick_connects
  lambda_function_associations = {
    voice-mail-packager         = module.voice_mail_packager_lambda.lambda_function_arn
    kvs-to-s3                   = module.kvs_to_s3_lambda.lambda_function_arn
    voice-mail-presigner        = module.voice_mail_presigner_lambda.lambda_function_arn
    voice-mail-transcriber      = module.voice_mail_transcriber_lambda.lambda_function_arn
    get-connect-config          = module.get_connect_config_lambda.lambda_function_arn
    check-holiday-and-hoop      = module.check_holiday_and_hoop_lambda.lambda_function_arn
    match-extension             = module.match_extension_lambda.lambda_function_arn
    lead-generation-lambda      = module.lead_generation_lambda.lambda_function_arn
    campaign-attribution-lambda = module.campaign_attribution_lambda.lambda_function_arn
  }
  tags = local.tags
}