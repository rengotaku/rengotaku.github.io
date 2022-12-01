---
title: "[AWS] Refer to values other threads"
tags: ["rds", "aws", "aurora"]
---

# Problem
I found a event "DB instance shutdown" in [RDS Management Console](https://ap-northeast-1.console.aws.amazon.com/rds/home?region=ap-northeast-1#event-list:) and why happened?

# Solution
I check a log `error/mysql-error-running.log`, this is seen in below(you should change `id` as your cluster name of rds):
https://ap-northeast-1.console.aws.amazon.com/rds/home?region=ap-northeast-1#database:id=staging-hoge-db-02-01;is-cluster=false;tab=logs-and-events

In my case RDS's log said as below:
```
Available memory is low. Trying to avoid OOM crash: system KB: 2014212 available KB: 0 low-threshold KB: 100710 print victim: yes decline query: no tune caches: yes kill query: no kill connection: no
OOM crash avoidance: kill option to avoid low memory: MySQL thread id 416, OS thread handle 47468632368896, query id 1820326 255.255.255.255 hoge_database FULLTEXT initialization
SELECT ...
OOM crash avoidance: kill option to avoid low memory: MySQL thread id 417, OS thread handle 47468645209856, query id 1820492 255.255.255.255 hoge_database Sending data
```

I suppose what some query caused OOM is the reason.