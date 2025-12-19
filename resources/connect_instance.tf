module "amazon_connect" {
  source                             = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=v1.0.3"
  region_prefix                      = local.region_prefix
  company_prefix                     = var.company_prefix
  env                                = var.env
  name                               = format("%s-connect-%s-%s", var.company_prefix, local.region_prefix, var.env)
  create_instance                    = var.is_primary
  instance_id                        = var.is_primary ? null : data.aws_connect_instance.amazon_connect.id
  instance_identity_management_type  = "SAML"
  instance_storage_configs           = local.instance_storage_configs
  multi_party_conference_enabled     = true
  instance_contact_flow_logs_enabled = true
  hours_of_operations                = { for k, v in local.hours_of_operations : k => v if var.is_primary }
  queues                             = { for k, v in local.queues : k => v if var.is_primary }
  contact_flows                      = { for k, v in local.contact_flows : k => v if var.is_primary }
  quick_connects                     = { for k, v in local.quick_connects : k => v if var.is_primary }
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
