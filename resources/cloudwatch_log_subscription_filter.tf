module "lead_generation_lambda_error_log_filter" {
  source                          = "git@github.com:CloverHealth/ccaas-terraform-modules.git//terraform-aws-cloudwatch//modules//log-subscription-filter?ref=master"
  create                          = true
  name                            = format("%s-err-log-filter-lead-generation-lambda-%s-%s", var.company_prefix, local.region_prefix, var.env)
  filter_pattern                  = "{ $.level = \"ERROR\" }"
  destination_arn                 = module.slack_notifier_lambda_alias_live.lambda_alias_arn
  log_group_name                  = module.lead_generation_lambda.lambda_cloudwatch_log_group_name
  depends_on = [
    module.slack_notifier_lambda,
    module.lead_generation_lambda
  ]
}


module "campaign_attribution_lambda_error_log_filter" {
  source                          = "git@github.com:CloverHealth/ccaas-terraform-modules.git//terraform-aws-cloudwatch//modules//log-subscription-filter?ref=master"
  create                          = true
  name                            = format("%s-err-log-filter-campaign-attribution-lambda-%s-%s", var.company_prefix, local.region_prefix, var.env)
  filter_pattern                  = "{ $.level = \"ERROR\" }"
  destination_arn                 = module.slack_notifier_lambda_alias_live.lambda_alias_arn
  log_group_name                  = module.campaign_attribution_lambda.lambda_cloudwatch_log_group_name
  depends_on = [ 
    module.slack_notifier_lambda,
    module.campaign_attribution_lambda
  ]
}

