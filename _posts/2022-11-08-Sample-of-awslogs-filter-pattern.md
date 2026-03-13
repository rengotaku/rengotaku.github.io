# Example
```
awslogs get -w -G -S "/ecs/task" "rails/*" --watch -f "{ ($.status != 200) && ($.path != \"/service/v2/hoge\") }"
```
This pattern works for getting logs that has error status and excluding specific url path.

# References
[Filter and pattern syntax - Amazon CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html#metric-filters-extract-json)