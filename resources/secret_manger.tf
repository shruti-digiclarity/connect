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

module "connect_slack_notifier_secret" {
  source = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-secrets-manager-wrapper?ref=v1.0.2"

  items = {
    connect_lead_generation = {
      name                    = "aws-connect-slack-notifier"
      description             = "Secret for connect slack notifier"
      secret_string           = jsonencode({})
      tags                    = local.tags
      create                  = true
      recovery_window_in_days = 30
    }
  }
}

module "iam_user_crerdentials_secret" {
  source = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-secrets-manager-wrapper?ref=v1.0.2"

  items = {
    iam_user_crerdentials = {
      name        = format("%s-smgr-iam-vm-user-details-%s-%s", var.company_prefix, local.region_prefix, var.env)
      description = "Secret for IAM user credentials"
      secret_string = jsonencode({
        username          = module.iam_user.iam_user_name
        access_key_id     = module.iam_user.iam_access_key_id
        secret_access_key = module.iam_user.iam_access_key_secret
        user_arn          = module.iam_user.iam_user_arn
        created_date      = timestamp()
      })
      tags                    = local.tags
      create                  = true
      recovery_window_in_days = 30
    }
  }
}