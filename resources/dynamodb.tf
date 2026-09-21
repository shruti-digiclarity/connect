# data "aws_kms_key" "west2_common_key" {
#   count    = var.is_primary ? 1 : 0
#   provider = aws.secondary_region
#   key_id   = "alias/${var.company_prefix}-kms-common-key-usw2-${var.env}"
# }

module "connect_config_dynamodb" {
  create_table                       = var.is_primary ? true : false
  source                             = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-dynamodb-table-wrapper?ref=v1.0.7"
  name                               = format("%s-dydb-connect-config-%s-%s", var.company_prefix, local.region_prefix, var.env)
  billing_mode                       = "PAY_PER_REQUEST"
  deletion_protection_enabled        = true
  hash_key                           = "path"
  range_key                          = null
  read_capacity                      = 0
  restore_date_time                  = null
  restore_source_name                = null
  restore_source_table_arn           = null
  restore_to_latest_time             = null
  stream_enabled                     = true
  stream_view_type                   = "NEW_AND_OLD_IMAGES"
  table_class                        = "STANDARD"
  write_capacity                     = 0
  server_side_encryption_enabled     = true
  server_side_encryption_kms_key_arn = module.common_aws_kms_key.key_arn
  attributes = [{
    name = "path"
    type = "S"
  }]
  # replica_regions = var.is_primary ? [
  #   {
  #     region_name            = "us-west-2"
  #     kms_key_arn            = try(data.aws_kms_key.west2_common_key[0].arn, "")
  #     propagate_tags         = true
  #     point_in_time_recovery = true
  #   }
  # ] : []
  point_in_time_recovery_enabled        = true
  point_in_time_recovery_period_in_days = 7
  ttl_attribute_name                    = null
  ttl_enabled                           = false
  tags                                  = local.tags
}

# module "connect_config_dynamodb_global" {
#   create_table                       = var.is_primary ? true : false
#   source                             = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-dynamodb-table-wrapper?ref=v1.0.7"
#   name                               = format("%s-dydb-connect-config-%s", var.company_prefix, var.env)
#   billing_mode                       = "PAY_PER_REQUEST"
#   deletion_protection_enabled        = true
#   hash_key                           = "path"
#   range_key                          = null
#   read_capacity                      = 0
#   restore_date_time                  = null
#   restore_source_name                = null
#   restore_source_table_arn           = null
#   restore_to_latest_time             = null
#   stream_enabled                     = true
#   stream_view_type                   = "NEW_AND_OLD_IMAGES"
#   table_class                        = "STANDARD"
#   write_capacity                     = 0
#   server_side_encryption_enabled     = true
#   server_side_encryption_kms_key_arn = module.common_aws_kms_key.key_arn
#   attributes = [{
#     name = "path"
#     type = "S"
#   }]
#   replica_regions = var.is_primary ? [
#     {
#       region_name            = "us-west-2"
#       kms_key_arn            = try(data.aws_kms_key.west2_common_key[0].arn, "")
#       propagate_tags         = true
#       point_in_time_recovery = true
#     }
#   ] : []
#   point_in_time_recovery_enabled        = true
#   point_in_time_recovery_period_in_days = 7
#   ttl_attribute_name                    = null
#   ttl_enabled                           = false
#   tags                                  = local.tags
# }