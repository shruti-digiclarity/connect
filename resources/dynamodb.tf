module "connect_config_dynamodb" {
  source                             = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-dynamodb-table-wrapper?ref=v1.0.3"
  name                               = format("%s-dydb-connect-config-%s-%s", var.company_prefix, local.region_prefix, var.env)
  billing_mode                       = "PAY_PER_REQUEST"
  deletion_protection_enabled        = false
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
  point_in_time_recovery_enabled = false
  ttl_attribute_name             = null
  ttl_enabled                    = false
  tags                           = local.tags
}
