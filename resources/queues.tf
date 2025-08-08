locals {
  queues = {
    ch_dnis_error = {
      description           = "Error Queue for DNIS."
      hours_of_operation_id = module.amazon_connect.hours_of_operations["dnis_error_hours"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
  }
}
