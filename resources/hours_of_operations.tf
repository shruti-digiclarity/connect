locals {
  hours_of_operations = {
    dnis_error_hours = {
      description = "Always open hours for error queue"
      time_zone   = "EST"
      config = [
        {
          day        = "SUNDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "MONDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "TUESDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "WEDNESDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "THURSDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "FRIDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "SATURDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        }
      ]
      tags = local.tags
    }
    ch_24x7_hours = {
      description = "Always open hours"
      time_zone   = "EST"
      config = [
        {
          day        = "SUNDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "MONDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "TUESDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "WEDNESDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "THURSDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "FRIDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "SATURDAY"
          start_time = { hours = 12, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        }
      ]
      tags = local.tags
    }
  }
}
