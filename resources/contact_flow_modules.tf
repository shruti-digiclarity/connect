locals {
  contact_flow_modules = {
    "ch_voice_mail_module" = {
      content     = file("${path.module}/contact-flow-modules/ch_voice_mail_module.json")
      description = "Voice Mail Module for CH"
    }
  }
}
