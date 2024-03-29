---
title: "コードレビューを通過するための CL 作成者のガイド を読んで"
tags: ["review", "management"]
---

[コードレビューを通過するための CL 作成者のガイド | google-eng-practices-ja](https://fujiharuka.github.io/google-eng-practices-ja/ja/review/developer/)

## 適切な CL のディスクリプションを書く
* CL とは何が変更され、なぜ変更されたのかを説明する記録です。
  * (FYI)Gitでいうコミット
* おぼろげな記憶を頼りに検索する場合に、重要な情報がすべてコードにだけ書かれていて説明欄に記載されていないと探している CL を見つけるのが非常に難しくなる
* 一行目
  * 何を行っているのかを短く要約する
  * 完全な文で、~~命令形で書く~~
    * "完全な文"のみ意識すれば良さそう。
    * 例)「FizzBuzz RPC を削除し、新しいシステムに置き換える。」
  * 次の行は空行にする
* 二行目以降
  * 解決されている問題に関する短い説明
  * なぜこれが最良の方法なのかを説明することもあります。(その方法に欠陥があれば、その点にも言及してください。)
  * また関連があれば、バグチケットの番号やベンチマーク結果、設計ドキュメントのリンク等の背景

**適切な CL ディスクリプションの例**
以下は適切なディスクリプションの例です。

```
機能変更
rpc: RPC サーバーのメッセージフリーリストのサイズ制限を取り除く。

FizzBuzz のようなサーバーには巨大なメッセージがあり、再利用することでメリットがある。フリーリストを大きくし、徐々にフリーリストエントリーを解放する goroutine を追加することで、アイドリング中のサーバーが最終的にすべてのフリーリストエントリーを解放するようにした。
```

## 小さな CL
小さくシンプルな CL の利点
* 速くレビューできる
  * レビュアーにとっての容易さ
    * 小さな CL をレビューするための 5 分間を数回確保 > 大きな CL をレビューするための 30 分をまとめて確保
  * (IMO)似通った修正点（or 同一ファイルの修正）が数個のCLに健在すると逆に時間がかかるかも
* 隅々までレビューできる
  * 変更が大規模だとあっちこっちに詳細なコメントを（ CL のディスクリプションに）大量に書かねばならず大変
* バグが混入する可能性が減る
  * 変更箇所が少なければ、開発者もレビュアーも CL の影響範囲が予測しやすく、バグが混入したかどうかを見分けやすい
* CL が却下されても無駄になる作業が少ない
  * 巨大な CL を書いてからレビュアーに全体的な方向性が間違っていると言われると、多くの作業が無駄になってしまいます。
  * (IMO)既存を真似てコントローラーを増やすなどではなく、集計処理を非同期で処理するなど通常とは違うことを書く場合はレビュー前にコミュニケーションを取る
* マージしやすい
  * 大規模な CL での作業には時間がかかるため、マージする頃には多くのコンフリクトが発生し、頻繁にマージしなければならない
  * (IMO)同一プロダクトをチームを分けて機能を実装する場合はより気をつけたい
* 設計を改善しやすくなる
  * 小さな変更の設計やコードの健康状態を改善するほうが簡単
* レビューによって作業がブロックされなくなる
  * あなたがしようとしている変更全体のうち一部を自己完結的な CL にして提出すれば、現在の CL のレビューを待つ間にコーディング作業を続けられる
  * (NOTE)ある機能を作成する上でA, B, Cファイルを修正する場合。Aの修正は、B, Cに影響しない場合は、Aのみの CL を作成しレビューを行い、B, Cの実装を進められる
* ロールバックしやすい
  * 大きな CL は多くのファイルにわたって変更するため、最初に CL を提出してからロールバックの CL までにそれらのファイルが変更され、ロールバックが複雑になる。（その CL 以降の CL もロールバックする必要が生じることもあります）
  * (NOTE)A, B, Cファイルを一つの CL に含めると、Aのみをロールバックしたい場合にB, Cも考慮しなくてはならなくなる
  * (IMO)ロールバックをするよりも修正して擬似ロールバックを行う方法を採用している

**「小さい」とはどういうことか？**
* CL がただ一つのことに取り組むミニマルな変更を行っている
* レビュアーがその CL について理解する必要のあるすべての情報 (将来の開発を除く) が CLや、CL ディスクリプション、既存のコードベース、これまでレビューした CL の中にある
* CL がその含意がわかりにくくなるほどに過剰に小さくない
  * 新しい API を追加するのなら、同じ CL の中にその API の使い方を含めるべきです。それはレビュアーが API の使い方をきちんと理解できるようになるため
* 小さい CL の目安は、100 行は適度なサイズで、1000 行になると大きすぎる

**どのようなときに大きな CL でも良いか？**
* 一つのファイルをまるごと削除する場合は、一行だけの変更とみなしても良い
  * レビューするのにそれほど長い時間がかからないから
* 大規模な CL がリファクタリングツールによって自動生成される場合があります。そのツールをあなたが完全に信頼していれば、そういった CL が大きくても良い。
  * (IMO)Rubocopなどの自動修正のみの CL を作成する。
* ファイルによる分割
  * CL を分割する他のやり方として、別々のレビュアーを必要とするという点を除けば自己完結的な変更となる複数のファイルをひとまとめにグループ分けするというのがあります。
  * (NOTE)例として考えられるのは、①ビジネスロジックを担うクラスに関する CL、②それを利用したコントローラーに関する CL がある。②は①の部分をモックで実装してレビューワーに依頼する。①は複雑なためジックリとレビュワーにレビューしてもらう
* リファクタリングを分離する
  * 機能変更やバグ修正と、リファクタリングは別の CL にするのが普通はベストです。
  * (IMO)参考にしたコードの書式が改善の余地があり修正する場合は、別の CL にするのがベストかも
* 関連するテストコードを同じ CL に含める
  * 独立したテストの修正は別々の CL にして先に提出しても良い
* ビルドを壊さない
  * (Q)なんとなく分かるが具体的な例が思いつかない
* 十分小さくできない場合
  * 大規模な CL を書く前に、事前にリファクタリングだけの CL を送ればもっとすっきりした実装をする方法が用意する
  * チームメンバーに相談し、その機能を小さな CL に分割できる実装方法を考えつくかどうか確認する
  * 上記の施策でもうまく行かない場合、大きな CL をレビューすることについて事前にレビュアーから同意を得る
    * (IMO)大事かもしれない。レビューワーに依頼した時に、レビューワーの別の作業に対してのインパクトを意識した方が良い

## レビューコメントの対応の仕方
**個人の人格へのコメントとして受け取らない**
* 心構え
  * ときにはレビュアーが苛立って、そのイライラをコメントに表現することもある
    * 「レビュアーが私に伝えようとしている建設的な事柄は何だろう？」と自身に問いかける。
  * コードレビューコメントに対して怒りに任せて反応しないでください。
    * しばらく席を立って歩いたり他の作業に当たったりして、気持ちが落ち着いて丁重な応答ができるようになるのを待つ

**コードを修正する**
* レビュアーがあなたのコードに理解できない箇所がある場合
  * 最初に行うべきはコードをリファクタリングすること。
  * ダメなら、なぜそのコードがそこにあるのか理由を書いたコメントをコードに追加する
  * 最後の手としてコメントの追加では足りない場合に限り、コードレビューツール上で説明する
    * (NOTE)Github上のコメントで説明書くならコードに書いた方が良き

**自分で考える**
* CL をレビューに送り出すとすっかり満足して、これで仕事が完了したと感じ、これ以上作業が必要ないと思い込んでしまうことがよくある
  * どれだけ自分が正しいと確信していたとしても、少し立ち止まって、レビュアーがコードベースと プロダクト を良くする価値あるフィードバックを書いているのではないかと考える
  * 常日頃から「レビュアーが正しいのではないか？」と自問自答する
* 問いを考えた上でなお自分が正しいと思えるなら、あなたのやり方のほうがコードベースにとってもユーザーにとっても、また プロダクト にとっても良いといえる理由を気兼ねなく説明する
  * レビュアーは実際には提案をしていて、何が最良なのかは開発者自身に考えてほしいと思っている
  * 開発者はユーザーについて、コードベースについて、CL についてレビュアーの知らないことを知っていることもあります。そういうときには知識のギャップを埋める
    * (IMO)ちょっとした実装のチップスをGithubのPRのコメントで残して貰えると助かる
