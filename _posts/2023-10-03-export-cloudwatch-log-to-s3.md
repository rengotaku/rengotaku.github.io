---
title: "Cloudwatchの指定のログをS3にエクスポートする"
tags: ["aws", "cloudwatch", "s3"]
---

[Export log data to Amazon S3 using the console - Amazon CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/S3ExportTasksConsole.html#ExportSingleAccount)

Cloudwatchで指定したロググループのログの出力先となるS3のバケットをTerraformで作成する。

# 前提
terraformバージョン: 0.12.30
AWSアカウントパーミッション: AdministratorAccess(SSO)

# Terraform
```
# CloudWatchのロググループから調査用にS3に出力する先
resource "aws_s3_bucket" "example_log_analysis" {
  bucket = "example-log-analysis"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.ap-northeast-1.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::example-log-analysis", # example-log-analysis をバケット名に変更
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "xxxxxx" # 自身のAccount IDに変更
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:ap-northeast-1:xxxxxx:log-group:*" # 自身のAccount IDに変更
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.ap-northeast-1.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::example-log-analysis/*",  # example-log-analysis をバケット名に変更
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "771306112264",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:ap-northeast-1:xxxxxx:log-group:*" # 自身のAccount IDに変更
                }
            }
        }
    ]
}
POLICY
}
```