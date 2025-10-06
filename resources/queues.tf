locals {
  queues = {
    ch_dnis_error = {
      description           = "Error Queue for DNIS."
      hours_of_operation_id = module.amazon_connect.hours_of_operations["dnis_error_hours"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
    ch_quick_connect_queue = {
      description = "Quick Connect Queue"
      hours_of_operation_id = module.amazon_connect.hours_of_operations["ch_24x7_hours"].hours_of_operation_id
      statement = "ENABLED"
      quick_connect_ids = []
      tags = local.tags
    }
  }
}
