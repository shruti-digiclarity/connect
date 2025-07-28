locals {
  contact_flows = {
    "ch_voice_mail_flow" = {
      content = templatefile(
        "${path.module}/contact-flows/ch_voice_mail_flow.json.tftpl",
        {
          ch_voice_mail_module = try(module.amazon_connect[0].contact_flow_modules["ch_voice_mail_module"].contact_flow_module_id, "")
        }
      )
      type        = "CONTACT_FLOW"
      description = "ch_voice_mail_flow"
      tags        = local.tags
    }
  }
}
