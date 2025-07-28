module "security_profile_stack" {
  count        = var.is_primary ? 1 : 0
  source       = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-cloudformation-wrapper?ref=main"
  name         = "${var.company_prefix}-${var.lob}-security-profiles"
  template_url = "https://${var.company_prefix}-s3-cfn-stack-templates-${local.region_prefix}-${var.env}.s3.${var.region}.amazonaws.com/${var.lob}/${local.region_prefix}/security-profile/ch-${var.lob}-security-profile-${local.file_hash_map["ch-telesales-security-profile.yaml"]}.yaml"
  parameters = {
    pConnectInstanceArn = module.amazon_connect.instance_arn
    pCompanyPrefix      = var.company_prefix
    pLOB                = var.lob
  }
  depends_on = [module.s3_cfn_objects]
}
