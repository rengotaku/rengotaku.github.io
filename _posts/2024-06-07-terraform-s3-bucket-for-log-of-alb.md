---
title: "[TERRAFORM]ALBのアクセスログの出力先のS3を作成"
tags: ["terraform", "aws", "s3"]
---

# 概要
ALBのアクセスログの出力先として作成するS3のテンプレートを記す

## Terraformバージョン
```
$ terraform -v                           
Terraform v1.7.5
on darwin_arm64
```

## リソース定義
```
resource "aws_s3_bucket" "alb_access_log" {
  bucket        = "alb-access-log"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "alb_access_log" {
  bucket = aws_s3_bucket.alb_access_log.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::582318560864:root" # Asia Pacific (Tokyo)
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alb-access-log/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_access_log" {
  bucket = aws_s3_bucket.alb_access_log.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

## Tips
### 出力先として選択したらpermissionエラーが発生する
アクセスの出力先に作成したS3を選択すると`Access Denied for bucket: alb-access-log. Please check S3bucket permission`とエラーが発生する。

https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#access-log-create-bucket の `Regions available as of August 2022 or later`を適用していた為に発生していた。

```
      "Principal": {
        "Service": "logdelivery.elasticloadbalancing.amazonaws.com"
      },
```