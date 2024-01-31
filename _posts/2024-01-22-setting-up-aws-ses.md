---
title: "AWS SESのSMTPを利用してメールを送信する"
tags: ["mail", "ses", "aws", "sns", "rails"]
---

# やりたいこと
* AWS SESが提供しているSMTPを利用してメールを送信
* メールの配信状態を確認

# 資料
[Set up email sending with Amazon SES - Amazon Simple Email Service](https://docs.aws.amazon.com/ses/latest/dg/send-email.html)
公式情報。`Set up email sending -> Using the SMTP interface`、`Verified identities`が対象となる。

[Send Email with Amazon SES in Ruby on Rails - Lazy Programmer](https://lazyprogrammer.me/send-email-with-amazon-ses-in-ruby-on-rails/)
メール送信までを分かりやすくまとめてくれている。

# メール送信
## Credentialを取得する（ユーザ作成）
ダッシュボードの`Create SMTP credentials`をクリックしてユーザを作成します。

ポリシーには`AmazonSesSendingAccess`が付与されているはず
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ses:SendRawEmail",
            "Resource": "*"
        }
    ]
}
```

## Verified Identitiesの設定（送信先の許可）
Domain(`yourdomain.com`)、送信元メールアドレス(`noreply@yourdomain.com`)を登録する。

Domainの確認でDNSを修正する必要がある。

## 設定
config/environments/production.rb
```
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'email-smtp.us-east-1.amazonaws.com', # use the endpoint from your AWS console
    :port => '587',
    :domain => host,
    :authentication => :plain,
    :user_name => 'your user name',
    :password => 'your password',
  }
```

app/mailers/application_mailer.rb
```
class ApplicationMailer < ActionMailer::Base
  ...
  default(from: -> { "\"yourname\" <noreply@yourdomain.com>" })
  ...
end
```

## 送信
```
TestMailer.notice.deliver_later
```

# メール送信状態確認
`Amazon SES`の`Notifications`にて、`Feedback notifications`を設定する。

作成した`Amazon SNS`のTopicの`Subscriptions`に追加する。

例えば、`https://api.yourdomain.com/ses_notifications.json`をEndpointに設定する。
エンドポイント内は下記のような処理となる。
```
class SesNotificationsController < ActionController::API
  def create
    data = JSON.parse(request.raw_post)

    if data.key?('SubscribeURL')
      # 確認のためSubscribeURLが含まれるリクエストが SNS から送信されるのでSubscribeURLにアクセスする
      open(data['SubscribeURL'])
    elsif data.key?('Message')
      # `notification['mail']`などで多彩な値を閲覧できる
      notification = JSON.load(data['Message'])
    end

    render json: {}, status: 200
  end
end
```
