---
title: "AWS・GCP・AzureやKubernetesなど、クラウドネイティブ環境5つのセキュリティ強化策 を読んで"
tags: ["aws", "security", "cloudtail"]
---

[AWS・GCP・AzureやKubernetesなど、クラウドネイティブ環境5つのセキュリティ強化策 ｜ビジネス+IT](https://www.sbbit.jp/document/sp/20266?ref=23082008btsw#continue_reading)

* AWS CloudTrail
  * AWS 環境で発生したアクティビティについて「誰が」「何を」「どこで」「いつ」実行したのかを追跡し、これらのアクティビティを監査ログに記録して、可視化および監査可能に。
  * 自社環境内で検知したアクティビティ（JSON 形式のオブジェクト。API リクエストやユーザーログインなど）をイベントとして記録します。
  * イベントをフィルタリングするイベントストリームを作成可能
    * ログ収集による負荷を軽減するため
  * ユーザーが指定した保持ポリシーに従ってイベントを利用でき、すばやくフィルタリングして重大な問題を特定でき下記サービスでアラートを発行できます。
    * Amazon CloudWatch
    * Amazon Simple Notification Service（SNS）
  * 証跡はすべてのリージョンで発生した関連イベントを記録（デフォルト）
    * 単一のリージョンのアクティビティのみを扱うシングルリージョン証跡を作成することもできるがお勧めできない
  * AWS マネジメントコンソール、コマンドラインインターフェイス（CLI）、および SDK/API でユーザーが実行したアクション、およびAWS によって自動的に実行されたアクションに基づいて、ほぼすべてのAWSサービスについて以下の 3 つのタイプのイベントを記録
    * 管理イベント：AWS アカウントのリソースについて実行された管理およびネットワーク（コントロールプレーン）オペレーションを記録。
      * セキュリティグループの設定変更
      * IAM ロールのアクセス許可の調整
      * AWS Virtual Private Cloud（VPC）ネットワークの変更
    * データイベント：データ要求オペレーションを記録
      * AWSのデータプレーンのリソースで実行される Get 、Delete 、および Put APIコマンド
    * Insight イベント : API 利用状況の履歴と比較して、AWS アカウントにおける通常とは異なる API のアクティビティを記録
      * 短時間における大量の API コール
  * CloudTrail のログを理解する
    * AWS 環境全体のアクティビティをモニタリングするために役立つ重要な情報が含まれる
      * すべてのイベントタイプの記録に含まれる重要ないくつかのフィールド
        * アクションを実行した AWS アイデンティティのアクセスキー ID（ userIdentity フィールド）
        * 実行されたアクションの詳細（ eventName、requestParameters ）
      * 管理イベントとデータイベントの記録
        * responseElements フィールド(アクションが正常に実行されたかどうかを判断に役立つ)次のスニペットでは、Alice という名前のユーザー（ userName ）が、Bob（ requestParameters ） という新しいユーザー（ eventName ）を作成するコールを実行したことがわかります。
  * 重要な CloudTrail の監査ログ
    * リソースベースのオペレーションで生成されるログの例は以下
      * コールの応答（ responseElements ）
      * 実行された API コール（ eventName ）
      * コマンドをコールしたユーザーやロールなどの識別情報（ userIdentity ）
    * ユーザーアカウント
      * 攻撃者が企業の環境に侵入する最も一般的な方法の 1 つは、公開されている
        * AWS シークレットアクセスキーを使用し、そのキーのアクセス許可を列挙して利用する許可されないユーザーのアクティビティログの responseElements には、以下のエラーメッセージが含まれます。
          * "errorCode": "Client.UnauthorizedOperation",
          * "errorMessage": "You are not authorized to perform this operation."
        * は悪意のあるアクションを実行するときに検出を回避するために、攻撃者は Amazon GuardDuty の脅威検出機能を無効にする場合がありGuardDuty 脅威検出機能の削除を示すインスタンスはすべて調査する価値がある
    * バケット
      * 以下のようなバケットの列挙や改ざんの攻撃手法を発見できます。
        * AWS S3 バケットの列挙(ListBuckets または PutBucketPolicy)
        * AWS S3 バケットポリシーの変更(DeleteAccountPublicAccessBlock)
    * ネットワーキングコンポーネント
      * AWS VPC の作成または変更
      * AWS ルートテーブルの作成または変更
      * AWS ネットワークゲートウェイの作成または変更
      * AWS ネットワークアクセスコントロールリストの作成または変更
      * AWS セキュリティグループの作成または変更
