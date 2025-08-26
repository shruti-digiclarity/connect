module "common_aws_kms_key" {
  source = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-kms-wrapper?ref=v1.0.1"

  name           = [format("%s-kms-common-key-%s-%s", var.company_prefix, local.region_prefix, var.env)]
  description    = "Encryption Decryption Key"
  multi_region   = false
  key_statements = local.key_statements
  tags           = local.tags

}   