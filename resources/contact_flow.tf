locals {
  contact_flows = {
    "ch_voice_mail_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_voice_mail_flow.json.tftpl",
        {
          ch_voice_mail_module = module.amazon_connect.contact_flow_modules["ch_voice_mail_module"].contact_flow_module_id
        }
      )
      type        = "CONTACT_FLOW"
      description = "ch_voice_mail_flow"
      tags        = local.tags
    }
    "ch_telesales_main_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_telesales_main_flow.json.tftpl",
        {
          telesales_oct_to_mar_hoo_arn = module.amazon_connect.hours_of_operations["telesales_oct_to_mar"].arn
          telesales_7th_dec_hoo_arn    = module.amazon_connect.hours_of_operations["telesales_7th_dec"].arn
          telesales_apr_to_sep_hoo_arn = module.amazon_connect.hours_of_operations["telesales_apr_to_sep"].arn
        }
      )
      type        = "CONTACT_FLOW"
      description = "ch_telesales_main_flow"
      tags        = local.tags
    }
    "ch_dnis_entry_preactions_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_dnis_entry_preactions_flow.json.tftpl",
        {
          ch_telesales_cms_en_queue_arn         = module.amazon_connect.queues["ch_telesales_cms_en"].arn
          get_contactflow_attributes_lambda_arn = module.get_connect_config_lambda.lambda_function_arn
        }
      )
      type        = "CONTACT_FLOW"
      description = "ch_dnis_entry_preactions_flow"
      tags        = local.tags
    }
  }
}
