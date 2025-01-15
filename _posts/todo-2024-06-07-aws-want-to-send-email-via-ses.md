---
title: "[AWS]SESでEMAIL配信を行いたい"
tags: ["terraform", "aws", "ses"]
---

# 概要
SESを経由してEmailの配信を行いたい

## 前提
* Workmailの開設が完了しておりユーザを登録すればメール受信は行える
  * https://hoge.awsapps.com/mail のようなURLでログインしてメールを確認できる
* SESにはドメインの検証が終了している
  * 送信するメールの検証が行えれば良い（メールの有効性の確認をWorkmailで行います）
* 作業するRegionは基本的にTokyo(ap-northeast-1)

## 手順
### Workmail
#### Userを作成する
https://us-west-2.console.aws.amazon.com/workmail/v2/home?region=us-west-2#/org/m-f683f42d16854d42bdf71d3be5af4896/users
`Users`


### SES
#### Identitiesを登録する
https://ap-northeast-1.console.aws.amazon.com/ses/home?region=ap-northeast-1#/identities
`Create identity`を押下して、`Identity type`で`Email address`を選択して、Workmailで作成したユーザのメールアドレスを作成する。