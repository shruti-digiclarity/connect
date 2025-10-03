locals {
  queues = {
    ch_dnis_error = {
      description           = "Error Queue for DNIS."
      hours_of_operation_id = module.amazon_connect.hours_of_operations["dnis_error_hours"].hours_of_operation_id
      status                = "ENABLED"
      tags                  = local.tags
    }
    quick_connect_queue = {
      description = "Quick Connect Queue"
      hours_of_operation_id = module.amazon_connect.hours_of_operations["ch_constant_hours"].hours_of_operation_id
      status = "ENABLED"
      quick_connect_ids = [
        data.aws_connect_quick_connect.jilliann_perez.quick_connect_id,
        data.aws_connect_quick_connect.janine_gutierrez.quick_connect_id,
        data.aws_connect_quick_connect.vanessa_osorio.quick_connect_id,
        data.aws_connect_quick_connect.christina_feindt.quick_connect_id
      ]
      tags = local.tags
    }
  }
}