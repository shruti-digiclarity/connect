locals {
  user_hierarchy_groups = {
    telesales = {
      name        = "Telesales"
      description = "Telesales group for the contact center"
      level       = 1
    }
  }
}

module "amazon_connect_admin_group" {
  count           = var.is_primary ? 1 : 0
  region_prefix   = local.region_prefix
  lob             = var.lob
  company_prefix  = var.company_prefix
  env             = var.env
  source          = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=main"
  create_instance = false
  instance_id     = module.amazon_connect.instance_id

  user_hierarchy_groups = {
    "admin" = {
      parent_group_id = module.amazon_connect.user_hierarchy_groups["telesales"].hierarchy_group_id
    }
  }
}

module "amazon_connect_supervisor_group" {
  count           = var.is_primary ? 1 : 0
  region_prefix   = local.region_prefix
  lob             = var.lob
  company_prefix  = var.company_prefix
  env             = var.env
  source          = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=main"
  create_instance = false
  instance_id     = module.amazon_connect.instance_id

  user_hierarchy_groups = {
    "supervisor" = {
      parent_group_id = module.amazon_connect_admin_group[0].user_hierarchy_groups["admin"].hierarchy_group_id
    }
  }

  depends_on = [module.amazon_connect_admin_group]
}

module "amazon_connect_qa_and_team_lead_groups" {
  count           = var.is_primary ? 1 : 0
  region_prefix   = local.region_prefix
  lob             = var.lob
  company_prefix  = var.company_prefix
  env             = var.env
  source          = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=main"
  create_instance = false
  instance_id     = module.amazon_connect.instance_id

  user_hierarchy_groups = {
    "qa" = {
      parent_group_id = module.amazon_connect_supervisor_group[0].user_hierarchy_groups["supervisor"].hierarchy_group_id
    }
    "team_lead" = {
      parent_group_id = module.amazon_connect_supervisor_group[0].user_hierarchy_groups["supervisor"].hierarchy_group_id
    }
  }

  depends_on = [module.amazon_connect_supervisor_group]
}

# Create agents under team_lead
module "amazon_connect_agent_under_team_lead" {
  count           = var.is_primary ? 1 : 0
  region_prefix   = local.region_prefix
  lob             = var.lob
  company_prefix  = var.company_prefix
  env             = var.env
  source          = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=main"
  create_instance = false
  instance_id     = module.amazon_connect.instance_id

  user_hierarchy_groups = {
    "agent" = {
      name            = "agent"
      parent_group_id = module.amazon_connect_qa_and_team_lead_groups[0].user_hierarchy_groups["team_lead"].hierarchy_group_id
    }
  }

  depends_on = [module.amazon_connect_qa_and_team_lead_groups]
}

# Create agents under qa
module "amazon_connect_agent_under_qa" {
  count           = var.is_primary ? 1 : 0
  region_prefix   = local.region_prefix
  lob             = var.lob
  company_prefix  = var.company_prefix
  env             = var.env
  source          = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-amazonconnect-wrapper?ref=main"
  create_instance = false
  instance_id     = module.amazon_connect.instance_id

  user_hierarchy_groups = {
    "agent" = {
      name            = "agent"
      parent_group_id = module.amazon_connect_qa_and_team_lead_groups[0].user_hierarchy_groups["qa"].hierarchy_group_id
    }
  }

  depends_on = [module.amazon_connect_qa_and_team_lead_groups]
}