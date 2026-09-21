locals {
  contact_flows = var.is_primary ? tomap({
    "ch_dnis_entry_preactions_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_dnis_entry_preactions_flow.json.tftpl",
        {
          ch_dnis_error_queue_arn       = module.amazon_connect.queues["ch_dnis_error"].arn
          getDidAttributes_us_east_1_function_arn = var.getDidAttributes_us_east_1_function_arn
          getDidAttributes_us_west_2_function_arn = var.getDidAttributes_us_west_2_function_arn
          lambda_function_name          = "${var.company_prefix}-lmda-get-connect-config-${local.region_prefix}-${var.env}"
        }
      )
      type        = "CONTACT_FLOW"
      description = "ch_dnis_entry_preactions_flow"
      tags        = local.tags
    }
    "ch_voice_mail_task_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_voice_mail_task_flow.json.tftpl",
        {
          ch_ihc_pcc_vm_queue_id                = data.aws_connect_queue.ihc_pcc_vm.queue_id
          ch_ihc_admin_coordinators_vm_queue_id = data.aws_connect_queue.ihc_admin_coordinators_vm.queue_id
        }
      )
      type        = "CONTACT_FLOW"
      description = "ch_voice_mail_task_flow"
      tags        = local.tags
    }
    "ch_common_queue_transfer_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_common_queue_transfer_flow.json", {}
      )
      type        = "QUEUE_TRANSFER"
      description = "ch_common_queue_transfer_flow"
      tags        = local.tags
    }
  }) : tomap({})
}
