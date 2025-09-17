{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3BucketPermissions",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "kms:Decrypt"
      ],
      "Resource": [
        "${bucket_arn}",
        "${bucket_arn}/*"
      ]
    }
  ]
}