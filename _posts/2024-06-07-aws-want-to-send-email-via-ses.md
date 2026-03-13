---
title: "[AWS]SESでEMAIL配信を行う設定ガイド"
tags: ["terraform", "aws", "ses", "workmail"]
---

# 概要

Amazon SES (Simple Email Service)を経由してメール配信を行うための設定手順をまとめる。Workmailと連携し、メール送受信環境を構築する。

## 前提条件

### 既に完了している設定
- **Workmail**: 組織の開設完了、ユーザー登録でメール受信可能
  - `https://[org-id].awsapps.com/mail` でメール確認可能
- **SES**: ドメインの検証完了
  - 送信メールアドレスの検証が必要（メールの有効性確認はWorkmailで実施）
- **作業Region**: 東京リージョン (ap-northeast-1) を基本とする

## 設定手順

### 1. Workmail設定

#### 1.1 ユーザー作成

1. Workmail管理コンソールにアクセス
   - URL: `https://[region].console.aws.amazon.com/workmail/v2/home`
2. 組織を選択 → `Users` タブ
3. `Create user` をクリック
4. 必要な情報を入力：
   - **Username**: メールアドレスのローカル部分
   - **Display name**: 表示名
   - **First/Last name**: 名前
   - **Password**: 初期パスワード

#### 1.2 メールボックスの確認

- 作成したユーザーでWorkmailにログイン
- メールの送受信が可能か確認

### 2. SES設定

#### 2.1 Identity（送信元アドレス）の登録

1. SES管理コンソールにアクセス
   - URL: `https://ap-northeast-1.console.aws.amazon.com/ses/home?region=ap-northeast-1#/identities`
2. `Create identity` をクリック
3. Identity typeで `Email address` を選択
4. Workmailで作成したユーザーのメールアドレスを入力
5. `Create identity` をクリック

#### 2.2 検証メールの確認

- Workmailのメールボックスに検証メールが届く
- メール内のリンクをクリックして検証完了

#### 2.3 サンドボックスモードの解除（本番環境の場合）

**サンドボックスモードの制限**:
- 検証済みのメールアドレスにのみ送信可能
- 1日あたり200通まで
- 1秒あたり1通まで

**解除手順**:
1. SESコンソール → `Account dashboard`
2. `Request production access` をクリック
3. 必要な情報を入力：
   - Use case description（ユースケースの説明）
   - Website URL（該当する場合）
   - Compliance（コンプライアンス対応）
4. 申請を送信（通常24時間以内に審査完了）

### 3. Terraform での自動化

#### 3.1 SES Identity リソース

```hcl
resource "aws_ses_email_identity" "main" {
  email = "user@example.com"
}
```

#### 3.2 SES Configuration Set（オプション）

送信イベントの追跡や、バウンス・苦情の処理に使用：

```hcl
resource "aws_ses_configuration_set" "main" {
  name = "main-config-set"
}

resource "aws_ses_event_destination" "cloudwatch" {
  name                   = "cloudwatch"
  configuration_set_name = aws_ses_configuration_set.main.name
  enabled                = true
  matching_types         = ["send", "bounce", "complaint"]

  cloudwatch_destination {
    default_value  = "default"
    dimension_name = "ses:configuration-set"
    value_source   = "messageTag"
  }
}
```

#### 3.3 IAMポリシー（アプリケーションからの送信用）

```hcl
data "aws_iam_policy_document" "ses_sender" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = [
      aws_ses_email_identity.main.arn
    ]
  }
}

resource "aws_iam_policy" "ses_sender" {
  name        = "ses-sender-policy"
  description = "Allow sending emails via SES"
  policy      = data.aws_iam_policy_document.ses_sender.json
}
```

## メール送信のテスト

### AWS CLI からのテスト

```bash
aws ses send-email \
  --from user@example.com \
  --destination ToAddresses=recipient@example.com \
  --message Subject={Data="Test Email"},Body={Text={Data="This is a test email"}} \
  --region ap-northeast-1
```

### アプリケーションからの送信例（Ruby on Rails）

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address:              'email-smtp.ap-northeast-1.amazonaws.com',
  port:                 587,
  user_name:            ENV['SES_SMTP_USERNAME'],
  password:             ENV['SES_SMTP_PASSWORD'],
  authentication:       'plain',
  enable_starttls_auto: true
}
```

## モニタリングと運用

### 1. CloudWatch メトリクス

監視すべき主要メトリクス：
- **Send**: 送信リクエスト数
- **Delivery**: 配信成功数
- **Bounce**: バウンス数
- **Complaint**: 苦情数
- **Reject**: 拒否数

### 2. バウンスと苦情の処理

- バウンス率が5%を超えると警告
- 苦情率が0.1%を超えると警告
- 継続的に高い場合、アカウント停止のリスク

### 3. レピュテーション管理

- 定期的にSESのレピュテーションダッシュボードを確認
- バウンスリストの管理
- 購読解除メカニズムの実装

## トラブルシューティング

### 送信エラーが発生する場合

1. **Identity未検証**: メールアドレスの検証を確認
2. **サンドボックスモード**: 本番アクセスリクエストの状態確認
3. **送信制限**: クォータの確認と必要に応じて引き上げリクエスト
4. **IAM権限**: 送信アプリケーションのIAM権限を確認

### バウンスが多い場合

1. メールアドレスの検証
2. DNSレコード（SPF、DKIM、DMARC）の設定確認
3. メールコンテンツの見直し（スパムフィルター対策）

## ベストプラクティス

1. **DKIM設定**: ドメイン認証を有効化してレピュテーション向上
2. **カスタムMAIL FROM**: バウンス処理を自ドメインで管理
3. **Configuration Set**: 送信イベントを追跡して改善
4. **購読解除リンク**: すべての配信メールに含める
5. **段階的な送信量増加**: 急激な送信量増加を避ける

## 参考リンク

- [Amazon SES 公式ドキュメント](https://docs.aws.amazon.com/ses/)
- [Workmail ユーザーガイド](https://docs.aws.amazon.com/workmail/)
- [Terraform AWS Provider - SES](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity)
