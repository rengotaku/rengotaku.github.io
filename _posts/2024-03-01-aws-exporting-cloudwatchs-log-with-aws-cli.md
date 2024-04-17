---
title: "[AWS]AWS CLIを利用してクラウドウォッチのログを出力する"
tags: ["aws", "cloudwatch", "awscli"]
---

# 参考
[Why and how to export data from CloudWatch Logs to S3 | TechTarget](https://www.techtarget.com/searchcloudcomputing/tip/Why-and-how-to-export-data-from-CloudWatch-Logs-to-S3)

# 前提
出力先のS3バケット（hoge-log-analysis）は作成済み。

# 前情報
* 対象となるLog groups名: hoge_production
  * 配下のlog group
    * /var/www/hoge/production/log/production.log
    * /var/log/nginx/access.log
* 出力先バケット: log-analysis
* バケット内の階層: log-output

# 実行コマンド
```
$ aws logs create-export-task --log-group-name "hoge_production" --from 1708959600000 --to 1709132400000 --destination "log-analysis" --destination-prefix "log-output"
```

* fromは`2024/02/27 00:00:00`、toは`2024/02/29 00:00:00`を表します
* Railsアプリケーションのログだけ必要な場合は、`log-stream-name-prefix`を指定する

**タスクの状況の確認**
上記の`{"taskId": "xxxx-xxxx-xxxx-xxxx-xxxx"}`のような出力がある。下記を実行する。
`status`で状況を確認できる。

```
$ aws logs describe-export-tasks --task-id "xxxx-xxxx-xxxx-xxxx-xxxx"

{
    "exportTasks": [
        {
            "taskId": "xxxx-xxxx-xxxx-xxxx-xxxx",
            "taskName": "hoge",
            "logGroupName": "hoge_production",
            "from": 1708959600000,
            "to": 1709132400000,
            "destination": "log-analysis",
            "destinationPrefix": "log-output",
            "status": {
                "code": "COMPLETED",
                "message": "Completed successfully"
            },
            "executionInfo": {
                "creationTime": 1709274790855,
                "completionTime": 1709274804946
            }
        }
    ]
}
```

## 正常に完了していると
`log-analysis/log-output/xxxx-xxxx-xxxx-xxxx-xxxx/`の配下にグルーブ毎のフォルダが生成され`000000.gz`のようなファイルがある。解凍するとログの中身が閲覧できる。

## Tips
### 存在する日時を指定してもログが出力されない
正しい日時を指定しているのに指定のフォルダに`aws-logs-write-test`しか生成されない場合は、桁数が足りていない可能性があります。
unix epochを求めようとして、[コチラ](https://www.unixtimestamp.com/)などを利用してはいけません。

渡すパラメーター(1708959600000)が13桁あることを確認してください。millisecondsの単位で生成してくれる[コチラ](https://currentmillis.com/)がお勧めです。

