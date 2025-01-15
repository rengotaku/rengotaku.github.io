---
title: "[AWS]SESで送信数の上限に達してしまう"
tags: ["aws", "ses"]
---

# 事象
アプリケーションで下記のエラーが発生して、メールが送信できない。
```
Net::SMTPServerBusy
454 Throttling failure: Maximum SigV2 SMTP sending rate exceeded.
```

## AWSコンソールのステータス
https://xxx.console.aws.amazon.com/ses/home#/account を閲覧すると下記の状態になっている。

**Sending limits**
* Daily sending quota
  * 50,000 emails per 24-hour period
* Maximum send rate
  * 14 emails per second

**Daily email usage**
* Emails sent
  * 51,000
* Remaining sends
  * -1,000
* Sending quota used
  * 102.00%

# 行ったこと
Sending limitsの`Request a limit increase`にて下記のメールを送信する。

```
Limit increase request 1
Service: Amazon Simple Email Service(Amazon SES)
Region: xxx
Limit name: Sending quota
New limit value: 70000.0
------------
Use case description: This support case was created by Service Quotas
```

# 受領待ち
7時に依頼して14時に返信が来た（サポート入っていないので、SeverityがGeneral question）

```
Thank you for submitting your request to increase your sending limits. We have granted your request. Your new sending quota is 70,000 messages per day. 

This takes effect immediately in the xxx region. You can view the current sending rate and sending quota for your account on the Sending Statistics page of the Amazon SES console, or by using the GetSendQuota API.

We also recommend that you:
-- Use the Amazon SES mailbox simulator to test your system so that your testing does not impact your account ( http://docs.aws.amazon.com/ses/latest/DeveloperGuide/mailbox-simulator.html  ).
-- Apply for higher sending limits before you need them ( https://docs.aws.amazon.com/ses/latest/dg/manage-sending-quotas.html  ).
```

# Tips
## 送信が可能になるタイミング
"Sending quota used"が100%を超えてから24時間待たないと送信できないという訳ではない。
スコープは1時間毎にズレる模様。

送信最大数が5000通の場合に下記で送信した。
3/1 1時・・・Emails sent: 1000、Remaining sends: 4000
3/1 2時・・・Emails sent: 2000、Remaining sends: 2000
3/1 11時・・・Emails sent: 3000、Remaining sends: -1000
...
3/2 1時・・・Emails sent: 0、Remaining sends: 0 # 3/1 1時の消費分が回復
3/2 2時・・・Emails sent: 1000、Remaining sends: 1000 # 3/1 2時の消費分が回復
