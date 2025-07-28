module "lambda_layer_backend" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=main"
  create                  = { layer = true }
  layer_name              = format("%s-lmda-voice-mail-common-layer-%s-%s", var.company_prefix, local.region_prefix, var.env)
  description             = "A layer for voice mail common functionalities."
  compatible_runtimes     = ["python3.12"]
  local_existing_package  = "../lambda_layer/ch-voice-mail-common-layer.zip"
  ignore_source_code_hash = true
  tags                    = local.tags
}
module "check_holiday_and_hoop_lambda_backend" {
  source                  = "git@github.com:CloverHealth/ccaas-terraform-modules-wrapper.git//terraform-aws-lambda-wrapper?ref=main"
  create                  = { layer = true }
  layer_name              = format("%s-lmda-check-holiday-and-hoop-layer-%s-%s", var.company_prefix, local.region_prefix, var.env)
  description             = "A layer for checking holidays and hoop functionalities."
  compatible_runtimes     = ["python3.12"]
  local_existing_package  = "../lambda_layer/ch-check-holiday-and-hoop-layer.zip"
  ignore_source_code_hash = true
  tags                    = local.tags
}
