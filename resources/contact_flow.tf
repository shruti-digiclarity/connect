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
    "ch_dnis_entry_preactions_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_dnis_entry_preactions_flow.json.tftpl",
        {
          ch_dnis_error_queue_arn       = module.amazon_connect.queues["ch_dnis_error"].arn
          get_connect_config_lambda_arn = module.get_connect_config_lambda.lambda_function_arn
        }
      )
      type        = "CONTACT_FLOW"
      description = "ch_dnis_entry_preactions_flow"
      tags        = local.tags
    }
  }
}
