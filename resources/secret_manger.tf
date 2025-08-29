module "connect_lead_generation_secret" {
  source = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-secrets-manager-wrapper?ref=v1.0.2"

  items = {
    connect_lead_generation = {
      name                    = "aws-connect-lead-generation"
      description             = "Secret for connect lead generation"
      secret_string           = jsonencode({})
      tags                    = local.tags
      create                  = true
      recovery_window_in_days = 30
    }
  }
}

module "connect_campaign_attribution_secret" {
  source = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-secrets-manager-wrapper?ref=v1.0.2"

  items = {
    connect_lead_generation = {
      name                    = "aws-connect-campaign-attribution"
      description             = "Secret for connect campaign attribution"
      secret_string           = jsonencode({})
      tags                    = local.tags
      create                  = true
      recovery_window_in_days = 30
    }
  }
}