---
title: "[AWS] How to register autoscaling of ECS via AWS CLI"
tags: ["aws", "ecs", "autoscaling"]
---

# Solution
Access AWS CloudShall, and then execute commands like belows:

## Check out your settings
Change the value of --resource-id like as "service/***"
```
[cloudshell-user@ip-xxx ~]$ aws application-autoscaling describe-scalable-targets --service-namespace ecs --resource-id service/cluter-name/service-name
{
    "ScalableTargets": [
        {
            "ServiceNamespace": "ecs",
            "ResourceId": "service/cluter-name/service-name",
            "ScalableDimension": "ecs:service:DesiredCount",
            "MinCapacity": 1,
            "MaxCapacity": 1,
            "RoleARN": "arn:aws:iam::0000:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService",
            "CreationTime": "2020-01-01T00:00:00.000000+00:00",
            "SuspendedState": {
                "DynamicScalingInSuspended": false,
                "DynamicScalingOutSuspended": false,
                "ScheduledScalingSuspended": false
            }
        }
    ]
}
```

## Register autoscaling settings
Change the value of --resource-id like as "service/***"
```
[cloudshell-user@ip-xxx ~]$ aws application-autoscaling register-scalable-target --service-namespace ecs --resource-id service/cluter-name/service-name --scalable-dimension ecs:service:DesiredCount --min-capacity 2 --max-capacity 2 --role-arn arn:aws:iam::0000:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService 
```

# References
* [application-autoscaling — AWS CLI 1.27.81 Command Reference](https://docs.aws.amazon.com/cli/latest/reference/application-autoscaling/)

* [Class: Aws::ApplicationAutoScaling::Client — AWS SDK for Ruby V3](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ApplicationAutoScaling/Client.html)
  * If you want implement as Ruby!