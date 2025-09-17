module "iam_role" {
  source                          = "git@github.com:CloverHealth/ccaas-terraform-modules.git//terraform-aws-iam//modules//iam-assumable-role?ref=master"
  create_role                     = true
  role_name                       = format("%s-iam-s3-replication-%s-%s", var.company_prefix, local.region_prefix, var.env)
  role_path                       = "/service-role/"
  force_detach_policies           = "true"
  create_custom_role_trust_policy = true
  custom_role_trust_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["s3.amazonaws.com", "batchoperations.s3.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  inline_policy_statements = [
    {
      sid    = "SourceBucketPermissions"
      effect = "Allow"
      actions = [
        "s3:ListBucket",
        "s3:GetReplicationConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionTagging",
        "s3:GetObjectRetention",
        "s3:Get*",
        "s3:Put*",
        "s3:Replicate*",
        "s3:Initiate*"
      ]
      resources = [
        module.s3_call_recording.bucket_arn,
        "${module.s3_call_recording.bucket_arn}/*"
      ]
    },
    {
      sid    = "DestinationBucketPermissions"
      effect = "Allow"
      actions = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:Replicate*",
        "s3:Get*",
        "s3:Put*",
        "s3:ListBucket"
      ]
      resources = [
        "arn:aws:s3:::${var.s3_destination_bucket_name}",
        "arn:aws:s3:::${var.s3_destination_bucket_name}/*"
      ]
    },
    {
      sid    = "SourceKMSPermissions"
      effect = "Allow"
      actions = [
        "kms:Decrypt"
      ]
      resources = [
        module.common_aws_kms_key.key_arn
      ]
    },
    {
      sid    = "DestinationKMSPermissions"
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:GenerateDataKey"
      ]
      resources = [
        "arn:aws:kms:${var.s3_destination_region}:${var.s3_destination_account_id}:key/${var.destination_kms_key_id}"
      ]
    }
  ]
}

module "iam_user_policy" {
  source        = "git@github.com:CloverHealth/ccaas-terraform-modules.git//terraform-aws-iam//modules//iam-policy?ref=master"
  create_policy = true
  name          = format("%s-iam-vm-s3-presigned-%s-%s", var.company_prefix, local.region_prefix, var.env)
  policy = [
    {
      sid    = "S3BucketPermissions"
      effect = "Allow"
      actions = [
        "s3:GetObject"
      ]
      resources = [
        module.s3_voice_mail_recording.bucket_arn,
        "${module.s3_voice_mail_recording.bucket_arn}/*"
      ]
    }
  ]
}
module "iam_user" {
  source        = "git@github.com:CloverHealth/ccaas-terraform-modules.git//terraform-aws-iam//modules//iam-user?ref=master"
  create_user   = true
  name          = format("%s-iam-vm-s3-presigned-%s-%s", var.company_prefix, local.region_prefix, var.env)
  force_destroy = "true"
  policy_arns = {
    s3_access = module.iam_user_policy.arn
  }
}
