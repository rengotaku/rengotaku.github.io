---
title: "[TERRAFORM]既存のリソースをTerraformに反映させる手順"
tags: ["terraform", "aws", "ses"]
---

# 概要
すでに設定しているCloudwatchをTerraformにインポートしたい。その手順を記す。

## Terraformバージョン
```
$ terraform -v                           
Terraform v1.7.5
on darwin_arm64
```

## 手順
`aws_cloudwatch.tf`に下記を記載する。

```
import {
  to = aws_cloudwatch_metric_alarm.elastic_cache_database_memory_usage_percentage_high
  id = "elastic-cache-database-memory-usage-percentage-high" # アラーム名
}
```

### リソースの書き出しを行う
`$ terraform plan -generate-config-out=aws_cloudwatch2.tf`

### terraform.tfstate に反映する
`$ terraform refresh`を実行する。

### Plan する
importブロックをコメントアウト（or削除する）を削除する。

```
$ terraform plan
...
No changes. Your infrastructure matches the configuration.
```

## Tips
### importしたリソースが新規リソースとして差分が発生する

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_cloudwatch_metric_alarm.elastic_cache_database_memory_usage_percentage_high will be created
  + resource "aws_cloudwatch_metric_alarm" "elastic_cache_database_memory_usage_percentage_high" {
      + actions_enabled                       = true
      + alarm_actions                         = [
          + "arn:aws:sns:ap-northeast-1:xxxxxxxxxxxxxxx:cloudwatch-alert-topic",
          + "arn:aws:sns:ap-northeast-1:xxxxxxxxxxxxxxx:junya-kenmochi-topic",
        ]
      + alarm_name                            = "elastic-cache-database-memory-usage-percentage-high"
      + arn                                   = (known after apply)
      + comparison_operator                   = "GreaterThanThreshold"
      + datapoints_to_alarm                   = 1
      + dimensions                            = {
          + "NodeGroupId"        = "0001"
          + "ReplicationGroupId" = "hoge"
        }
      + evaluate_low_sample_count_percentiles = (known after apply)
      + evaluation_periods                    = 1
      + id                                    = (known after apply)
      + metric_name                           = "DatabaseMemoryUsageCountedForEvictPercentage"
      + namespace                             = "AWS/ElastiCache"
      + period                                = 300
      + statistic                             = "Average"
      + tags_all                              = (known after apply)
      + threshold                             = 80
      + treat_missing_data                    = "missing"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

refreshする前にimportブロックを消してしまうと上記の現状が発生する。
importブロックは差分が発生しないことを確認できるまで削除しないようにしましょう。

### importブロックよりリソースを自動生成する際にエラー
すでに存在するファイル内にimportブロックを定義して、そのファイルにリソースを出力した句なるが、エラーが発生して行えない。

```
$terraform plan -generate-config-out=aws_cloudwatch.tf
╷
│ Error: Target generated file already exists
│ 
│ Terraform can only write generated config into a new file. Either choose a different target location or move all existing configuration out of the target file, delete it and try again.
╵
```

適当にファイル名にサフィックスをつけるなどして別名で出力させる。
`aws_cloudwatch_for_import.tf`

### メモ
別のインポートの仕方

```
resource "aws_s3_bucket" "test_bucket" {
  id = "test-bucket"
}
```

```
$ terraform import aws_s3_bucket.test_bucket test-bucket
```
