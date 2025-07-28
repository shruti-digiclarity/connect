locals {
  routing_profiles = {
    "ch_telesales_en" = {
      description               = "Telesales English Routing Profile"
      default_outbound_queue_id = module.amazon_connect.queues["ch_telesales_outbound"].queue_id

      media_concurrencies = [
        {
          channel     = "VOICE"
          concurrency = 1 // Always 1 for Voice
        }
      ]

      queue_configs = [
        {
          channel  = "VOICE"
          delay    = 0
          priority = 1
          queue_id = module.amazon_connect.queues["ch_telesales_en"].queue_id
        },
        {
          channel  = "VOICE"
          delay    = 0
          priority = 1
          queue_id = module.amazon_connect.queues["ch_telesales_cms_en"].queue_id
        }
      ]
      tags = local.tags
    }
    "ch_telesales_es" = {
      description               = "Telesales Spanish Routing Profile"
      default_outbound_queue_id = module.amazon_connect.queues["ch_telesales_outbound"].queue_id

      media_concurrencies = [
        {
          channel     = "VOICE"
          concurrency = 1 // Always 1 for Voice
        }
      ]

      queue_configs = [
        {
          channel  = "VOICE"
          delay    = 0
          priority = 1
          queue_id = module.amazon_connect.queues["ch_telesales_es"].queue_id
        },
        {
          channel  = "VOICE"
          delay    = 0
          priority = 1
          queue_id = module.amazon_connect.queues["ch_telesales_cms_en"].queue_id
        },
        {
          channel  = "VOICE"
          delay    = 0
          priority = 2
          queue_id = module.amazon_connect.queues["ch_telesales_en"].queue_id
        },
        {
          channel  = "VOICE"
          delay    = 0
          priority = 2
          queue_id = module.amazon_connect.queues["ch_telesales_cms_es"].queue_id
        }
      ]
      tags = local.tags
    }
  }
}
