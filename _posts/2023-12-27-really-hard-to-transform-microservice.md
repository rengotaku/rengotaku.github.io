---
title: "マイクロサービス化は本当に難しい を読んで"
tags: ["microservice"]
---

[マイクロサービス化は本当に難しい](https://zenn.dev/aeonpeople/articles/93e7a6cc84854d)

* サービス提供のアジリティを確保することが目的
  * [アジリティとは - 意味をわかりやすく - IT用語辞典 e-Words](https://e-words.jp/w/%E3%82%A2%E3%82%B8%E3%83%AA%E3%83%86%E3%82%A3.html)
    * ITの分野では、ソフトウェアや情報システム、およびその開発手法や体制などが、顧客の要望やビジネス環境の変化に素早く適応できる柔軟性
* 発生した問題
  * 段階的移行(ストラングラーフィグパターン)の予定が、いつの間にか同時移行(ビッグバーン)になった
    * ストラングラーフィグパターン
      * モノリスのシステムを部分的に切り出していって段階的にマイクロサービス化を進めていく方法
  * サービス分割単位の見直しとサービス間連係の方法の見直しが、スケジュール都合などで出来なかった
    * サービス間の依存が多く、サービス間のI/Fの増加
      * DBであれば**別テーブル参照やJOINするだけなのに、APIを呼び出す必要**がある(=APIが増加 and 仕様調整の収拾が付かない)
        * (IMO)別チームにDBの変更を伝えるのも億劫なのに、APIの仕様を連携する必要があるのは凄い面倒そう
    * サービス間を跨ぐトランザクション制御の必要性
      * 一般的には、サーガパターンが定型パターンだけど、適切に設計・実装するのは高難度。それを**複数のチームで同時に設計・実装するには学習コストや検証・試験を含めてコストが掛かり**すぎる。
        * [Sagaパターンについて #マイクロサービス - Qiita](https://qiita.com/yoshii0110/items/4ae10eb071565cb90b37)
          * 結果整合性を担保したい範囲を１つのローカルトランザクション(擬似的なトランザクション)と考えて処理を行います。
      * 特に**失敗した場合のロールバックの手間**が大きい。
    * REST API 仕様のすり合わせに難航する
      * 機能に基づいたサービス分割は、
        * 要求分析、要件定義の段階では、作業分担も明確になりスケールアウトして作業が出来た
        * 検討するフェーズを取る事が出来なくて、最終的にサービス間でのI/F・責務の調整で余計にコストが掛かった
        * (Q)検討するフェーズとは、要件定義と詳細設計の間ということか？
    * 結果的に**業務ドメインごとにサービス分割することが目的**となってしまった
      * (NOTE)目的は運アジリティの確保が、マイクロ化が目的の意味
  * サービス分割方法の失敗とサービス間の連係方法に課題を持ったまま進んだ
    * 現実的路線
      * モジュラーモノリスから始める。
        * [モジュラーモノリス - doc.dev1x.org](http://doc.dev1x.org/sweng/26/)
          * 機能毎にパッケージとして機能するようモジュール分割する、程度の意味。PythonならPyPIパッケージ、RubyならGem、node.jsならNPMパッケージ etc...
      * 必要に応じて、ストラングラーフィグパターンでマイクロサービス化を段階的に進めていく。
* 内部のサービス間の通信をREST APIにするのは悪手？
  * ベタープラクティス(補足: 内蔵の代謝 (免疫システム)は、生死に直結するが、社会的なコミュニケーション (自然言語など)は、そうではない。**特性が違うのでプロトコルが異なる**のは当然。)
   * サービス間の通信
      * 非同期: キュー
      * 同期: gRPCなどのスキーマ定義ありのプロトコルの採用
    * フロントエンドとの通信
      * REST API
    * トランザクション制御
      * まずはデータベースの分割はしない
      * 但し、後々データベースの分割を想定してテーブル設計をしておく
      * API間でのトランザクション境界が必要となるサービス分割をしない
