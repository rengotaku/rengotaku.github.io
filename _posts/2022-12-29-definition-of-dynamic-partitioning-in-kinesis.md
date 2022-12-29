---
title: "[Kinesis] Definition of dynamic partitioning in terraform"
tags: ["aws", "kinesis", "firehose", "terraform"]
---

# Problem
I found the example to use dynamic partitioning in Kinesis as below:
[aws_kinesis_firehose_delivery_stream | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream#extended-s3-destination-with-dynamic-partitioning)

This isn't working. I got a error as below:
`Error: error creating Kinesis Firehose Delivery Stream: InvalidArgumentException: Dynamic Partitioning Namespaces can only be part of a prefix expression when Dynamic Partitioning is enabled.`

# Solution
You need to definite [dynamic_partitioning_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream#dynamic_partitioning_configuration) as below:
```
extended_s3_configuration {
  dynamic_partitioning_configuration {
    enabled = "true"
    retry_duration = 300
  }
}
```