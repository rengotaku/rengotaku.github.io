---
title: "全文検索システムの移行"
tags: ["mysql", "opensearch", "elasticsearch", "aws"]
---

## 1. MySQL以外を利用
* AWSを中心に検討
* AWSにリソースがまとまっているため、メリットが大きくない限り、GCPなどは考えない
## 1.1 Amazon OpenSearch (ElasticSearch)
* AWSのApache Luceneベースの分散検索エンジン:  
  https://aws.amazon.com/jp/what-is/elasticsearch/
* カスタマイズすることで、より精度の高い検索が可能
* 検索ストレージをNoSQLデータベースの非構造化ドキュメントとして使用している

#### メリット
* 複雑な検索条件に対応
  * 1対多のデータ構造への対応が可能
  * 1項目に対して、複数の値を持つようなレコードを検索可能
  * オブジェクト型や親子関係のインデックスが用意されてる
* シノニム辞書のバージョン管理が可能
* CloudSearchに比べ、費用が安い

#### デメリット
* 検索要件に合わせて設計する必要がある
* 再インデックス処理をオペレーションする必要がある
* スケールはエンジニアが手動で行う必要がある

#### コスト(東京リージョン)
https://aws.amazon.com/jp/opensearch-service/pricing/
##### インスタンス
* t3.small.search   $0.056/hour = $40.32/month (m系のsmallがない)
* m3.medium.search	$0.135/hour = $97.2/month
* m3.large.search   $0.27/hour = $194.4/month
##### EBS ボリューム
* $0.1464 /GB/月

##### 試算
* staging環境: (t3.small.search + EBS 20GB) * 2 = ($40.32 + $2.928) * 2 = $86.496
* 本番: m3.large.search + EBS 50GB = $194.4 + $7.32 = $201.72
* 合計: $288.216

## 2.2 AWS CloudSearch
* AWSのマネージド型の検索ソリューションサービス
  https://aws.amazon.com/jp/cloudsearch/
* CloudSearchの裏ではElasticSearchが動いている

#### メリット
* マネージドサービスのため、運用が楽
  * データ量やトラフィックに合わせて、オートスケールしてくれる
  * 自動でインデックス更新してくれる
* 検索精度を上げるための言語処理の設計をする必要がない

#### デメリット
* フラットなデータ構造しか検索できない
  * オブジェクト型など1対多の構造に対応してない
* OpenSearchに比べ、費用が高い

#### コスト(東京リージョン)
https://aws.amazon.com/jp/cloudsearch/pricing/
##### インスタンス
* search.m1.small   $0.082/hour = $59.04/month
* search.m3.medium	$0.136/hour = $97.92/month
* search.m3.large   $0.272/hour = $195.84/month
##### データ転送
* 受信: 無料
* 送信: 
  * 最初の10 TB/月:  $0.140/GB
  * 次の40 TB/月:    $0.135/GB
##### 試算
* staging環境: (search.m1.small + 送信 10GB) * 2 = ($59.04 + $1.4) * 2 = $120.88
* 本番: search.m3.large + 送信 50GB = $195.84 + $6.8 = $202.64
* 合計: $323.52

## 他の方法
他に良い手段があれば、

* OSSの全文検索サーバーを用意? (Fessなど)