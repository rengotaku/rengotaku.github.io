---
title: "AWS Cloud Practitioner Essentials (Japanese) (Na) 日本語実写版 を受けて（パート2）"
tags: ["aws"]
---

[AWS Skill Builder](https://explore.skillbuilder.aws/learn/course/external/view/elearning/1875/AWS-Cloud-Practitioner-Essentials-Japanese-Na-)

# モジュール3
## AWS グローバルインフラストラクチャ
* リージョンAで保存したデータが他のリージョン送信することはない（リージョンが存在する国の法律に基づく）
* 近接性・・・レイテンシーを考慮して利用者に合わせたリージョン選択が必要
* アベイラビリティーゾーン(高可用性に作用)
  * 互いに数十マイル離れた位置
  * 10秒未満のレイテンシー
  * リージョン内で2つのアベイラビリティーゾーンをで実行する
* エッジロケーション
  * Amazon CloudFront で、コンテンツのキャッシュされたコピーをお客様の近くに保存するために使用する場所です。
  * またはRoute53
  * リージョンから分離している

## AWS リソースをプロビジョニングする方法
* AWS Elastic Beanstalk
  * Terraformを利用しなくてよさそう（AWS CloudFormation との違いが分からず）
* AWS CloudFormation
  * アカウントを超えて構築できるらしい。

# モジュール4
## AWS への接続
* Virtual Private Cloud (VPC)
  * パブリックトラフィックからVPC内にアクセスするためにはインターネットゲートウェイを用意する必要がある
  * プライベートトラフィックをアクセスするには、仮想プライベートゲートウェイを用意する必要がある
  * 公共の経路を利用するので低レイテンシーを求めるならAWS AWS Direct Connectを利用する
* サブネットとネットワークアクセスコントロールリスト
  * セキュリティグループとネットワークACLの違い
    * セキュリティグループ
      * EC2インスタンスに設定する
      * ステートフル(状態を管理する)
    * ネットワークACL
      * サブネットに設定
      * インバウンドトラフィックとアウトバウンドトラフィックを制御する仮想ファイアウォール

## 別サブネットに存在する別インスタンスのトラフィックの動き
VPC [サブネット1 [EC2 A]  サブネット2 [EC2 B] ]

* EC2Aのセキュリティーグループを突破
  * アウトバウンドはデフォルトで全て許可されている
* サブネット1を突破
  * ネットワークACLが許可リストに基づきトラフィックを制御（セキュリティーグループの結果は考慮しない）
* サブネット2を突破
  * ネットワークACLに設定されている内容はサブネット1とは違う場合がある
* EC2Bのセキュリティーグループを突破
  * ポートが許可されている

リターントラフィック
* EC2Bのセキュリティーグループを突破
  * 無条件で許可される
* サブネット2を突破
  * 転送先リストに載っているかチェックを行う
* サブネット1を突破
  * 転送先リストに載っているかチェックを行う
* EC2Aのセキュリティーグループを突破
  * 無条件で許可される(以前に許可したことを記憶している)