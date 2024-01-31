---
title: "NewRelic発生したアラートをAWS Connectを通して架電する方法"
tags: ["aws", "newrelic", "awsconnect", "lambda", "ruby"]
---

## 要件
NewRelicで監視しているシステムがダウンした際に、複数人にダウンした旨を架電したい。
架電内容は、どのシステムがダウンしたかメッセージが流れる。
また、システム毎に架電元の番号は違い固定であること。
架電先は、`050-xxx`。電話番号は国内、国外を問わない。

## 前提
[AWS EventBridgeとの連携によるインシデント対応の効率化（架電編） - New Relic](https://newrelic.com/jp/blog/how-to-relic/notification-awseventbridge) のAWS EventBridgeからAWS Lambdaを呼び出す箇所まで設定する。

## Lambdaの作成
2つのシステム(hoge, hoge2)からコールを想定してます。
アラートが発生したシステムを特定できるように、AWS Connectにシステム名を通知します。
また、`DESTINATION_PHONE_NUMBERS_JSON`には複数の電話番号を設定することにより、複数人に架電を行えます。
```
require 'aws-sdk'
require 'json'

SYSTEM_NAMES = {
  'hoge' => 'ホゲ',
  'hoge2' => 'ホゲ2'
}
SOURCE_PHONE_NUMBERS = {
  'hoge' => ENV['HOGE_SOURCE_PHONE_NUMBER'],
  'hoge2' => ENV['HOGE2_SOURCE_PHONE_NUMBER']
}

def lambda_handler(event:, context:)
  connect_call(event)
end

def connect_call(event)
  client = Aws::Connect::Client.new(region: 'ap-northeast-1')

  JSON.parse(ENV['DESTINATION_PHONE_NUMBERS_JSON']).each do |destination_phone_number|
    response = client.start_outbound_voice_contact(
      destination_phone_number: destination_phone_number, # required
      contact_flow_id: ENV['CONTACT_FLOW_ID'], # required
      instance_id: ENV['INSTANCE_ID'], # required
      source_phone_number: SOURCE_PHONE_NUMBERS[event['Type']],
      attributes: {
        "SystemName" => SYSTEM_NAMES[event['Type']]
      }
    )
  end
end
```

環境変数は下記のような設定です。
```
CONTACT_FLOW_ID	caaxxx-xx-xx-xx-xxx
DESTINATION_PHONE_NUMBERS_JSON	["+81123456789", "+81123456789"]
INSTANCE_ID	afxx-xx-xx-xx-xxx
HOGE_SOURCE_PHONE_NUMBER	+18123456789
HOGE2_SOURCE_PHONE_NUMBER	+18223456789
```
`INSTANCE_ID`、`HOGE_SOURCE_PHONE_NUMBER`、`HOGE2_SOURCE_PHONE_NUMBER`はAWS Connectを設定して取得します。

## AWS Connectの作成
### Amazon Connectでインスタンスを作成する
`Add an instance`を押下して、説明通りに必要情報を入力する。

[Amazon Connect インスタンス ID/ARN の検索 - Amazon Connect](https://docs.aws.amazon.com/ja_jp/connect/latest/adminguide/find-instance-arn.html) にてARNをメモっておく。

### 電話番号を取得する
AWS Connectの管理画面にログインする。
https://xxx.my.connect.aws/numbers#/ にて番号を取得する。

### Amazonサポートに問い合わせする
特に手続きが不要な米国の電話番号を利用することになった。

**補足**

[Amazon Connect の電話番号をアジアパシフィック (東京) リージョンで取得する - Amazon Connect](https://docs.aws.amazon.com/ja_jp/connect/latest/adminguide/connect-tokyo-region.html)

日本国の電話番号は取得の難易度が上がる。

#### サポート経由で制限解除をリクエストをする
**問い合わせ内容**

```
制限緩和のリクエスト 1
リージョン: アジアパシフィック (東京)
サービス: Amazon Connect
制限の名前: 日本 (東京) の電話番号
申請する上限数: 0
------------
申請理由の説明: 日本の電話番号への発信制限を解除したいです。

・解除したい電話番号のプレフィックス
090, 080, 070

・Connect インスタンスの ARN
arn:aws:connect:ap-northeast-1:77xxx:instance/afxxx-xx-xx-xx-xxxx
```

**返答**

```
ご希望通り、該当Connect Instanceから日本の携帯番号への発信制限を解除いたしました。
なお、別のConnect Instanceでも同様に発信制限の解除が必要となりましたら、お手数ですがそのConnect InstanceのARNを添えて別途解除をお申しつけください。
```

##### Tips
**問い合わせの項目**

サポートに問い合わせする際に、「申請する上限数:」はデフォルトで表示されるフォーマットで、発信制限解除のご依頼の際には特段意味をなさない項目。
記入時は「０」など任意の数字を記載いただき、「申請理由の説明」に発信制限の解除をご希望する具体的な番号を記入する

**デフォルトの解除番号**

[デフォルトで電話できる国 - Amazon Connect](https://docs.aws.amazon.com/ja_jp/connect/latest/adminguide/country-code-allow-list.html#prefixes-not-allowed)

`+8150` への発信制限は、デフォルトで解除されている。 

**問い合わせしたが正しく解除できていない**

解除を申請したが、問い合わせコントロールパネルにて電話の発信を試みると「発信先の電話番号は E.164 形式で入力できていると思います。（+8180XXXXXXXX）」が表示される。
再度問い合わせて解除の確認をしてもらうと、架電が行えた。（人間だもの）

### フローを作成する
AWS Connectの管理画面にログインする。
https://xxx.my.connect.aws/contact-flows にてニーズに合いそうなフローを真似て、フローを作成する。

**作成したフロー例**

`①コンタクト属性の設定 → ②音声の設定 → ③プロンプトの再生 → ④切断`

1. Lambdaで設定した`SystemName`をフロー内で扱えるようにします。
音声の設定
1. お好きな音声を選択
1. 「$.Attributes.SystemName のログインチェックに失敗しました。」をテキストで解釈させる設定をする。
1. 終了イベントを行います。