locals {
  queues = {
    ch_telesales_cms_en = {
      description           = "Telesales CMS English Queue."
      hours_of_operation_id = module.amazon_connect.hours_of_operations["telesales_apr_to_sep"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
    ch_telesales_cms_es = {
      description           = "Telesales CMS Spanish Queue"
      hours_of_operation_id = module.amazon_connect.hours_of_operations["telesales_apr_to_sep"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
    ch_telesales_en = {
      description           = "Telesales English Queue."
      hours_of_operation_id = module.amazon_connect.hours_of_operations["telesales_apr_to_sep"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
    ch_telesales_es = {
      description           = "Telesales Spanish Queue."
      hours_of_operation_id = module.amazon_connect.hours_of_operations["telesales_apr_to_sep"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
    ch_telesales_outbound = {
      description           = "Outbound Queue for Telesales."
      hours_of_operation_id = module.amazon_connect.hours_of_operations["telesales_apr_to_sep"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
  }
}
