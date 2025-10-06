locals {
  contact_flows = {
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
    "ch_voice_mail_task_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_voice_mail_task_flow.json.tftpl", {}
      )
      type        = "CONTACT_FLOW"
      description = "ch_voice_mail_task_flow"
      tags        = local.tags
    }
    "ch_common_queue_transfer_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_common_queue_transfer_flow.json.tftpl", {}
      )
      type = "QUEUE_TRANSFER"
      description = "ch_common_queue_transfer_flow"
      tags = local.tags
    }
  }
}
