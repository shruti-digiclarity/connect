module "amazon_connect" {
  source                            = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=master"
  region_prefix                     = local.region_prefix
  lob                               = var.lob
  company_prefix                    = var.company_prefix
  env                               = var.env
  name                              = format("%s-connect-%s-%s", var.company_prefix, local.region_prefix, var.env)
  create_instance                   = true
  instance_identity_management_type = "SAML"
  instance_storage_configs          = local.instance_storage_configs
  multi_party_conference_enabled    = false
  hours_of_operations               = local.hours_of_operations
  queues                            = local.queues
  routing_profiles                  = local.routing_profiles
  user_hierarchy_structure          = local.user_hierarchy_structure
  user_hierarchy_groups             = local.user_hierarchy_groups
  contact_flow_modules              = local.contact_flow_modules
  contact_flows                     = local.contact_flows
  tags                              = local.tags
  #lambda_function_associations = {
  #  get-contactflow-attributes         = mpdule.contactflow_attributes_lambda.lambda_function_arn
  #}
}

