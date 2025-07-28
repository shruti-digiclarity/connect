data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "match_extension_lambda_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem"
    ]
    resources = [
      module.connect_config_dynamodb.dynamodb_table_arn,
      "${module.connect_config_dynamodb.dynamodb_table_arn}/*"
    ]
  }
  statement {
    sid     = "AllowKMS"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      "arn:aws:kms:${var.region}:${var.account_number}:key/*"
    ]
  }
}
