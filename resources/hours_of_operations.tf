locals {
  hours_of_operations = {
    telesales_7th_dec = {
      description = "Working hours of telesales lob for 7th December"
      time_zone   = "EST"
      config = [
        {
          day        = "WEDNESDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "FRIDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "MONDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "SATURDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "TUESDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "THURSDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        },
        {
          day        = "SUNDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 12, minutes = 0 }
        }
      ]
      tags = local.tags
    }
    telesales_apr_to_sep = {
      description = "Working hours of telesales lob from April to September month"
      time_zone   = "EST"
      config = [
        {
          day        = "MONDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "TUESDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "WEDNESDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "THURSDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "FRIDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        }
      ]
      tags = local.tags
    }
    telesales_oct_to_mar = {
      description = "Working hours of telesales lob from October to March month"
      time_zone   = "EST"
      config = [
        {
          day        = "MONDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "TUESDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "WEDNESDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "THURSDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "FRIDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        },
        {
          day        = "SATURDAY"
          start_time = { hours = 8, minutes = 0 }
          end_time   = { hours = 21, minutes = 0 }
        }
      ]
      tags = local.tags
    }
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
  }
}
