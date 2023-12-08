---
title: "オンラインストレージの脆弱性対策について　を読んで"
tags: ["security"]
---

[オンラインストレージの脆弱性対策について | 情報セキュリティ | IPA 独立行政法人 情報処理推進機構](https://www.ipa.go.jp/security/security-alert/2023/alert20231019.html)

# 用語
* [標的型攻撃　APT攻撃とは？意味・定義 | ITトレンド用語 | ドコモビジネス | NTTコミュニケーションズ](https://www.ntt.com/bizon/glossary/j-h/hyoutekigata-apt-kougeki.html)
  * 標的型攻撃とは、特定の個人、あるいは組織を狙って行われる攻撃です。また、標的に対して持続的に行われる攻撃をAPT（Advanced Persistent Threat）攻撃と呼ぶこともあります。
* [OEMとは？種類やメリット・デメリット、OEM生産の注意点などを解説](https://squareup.com/jp/ja/townsquare/what-is-oem)
  * メーカーが自社ではないブランドの製品を製造することを指し、自動車や電化製品、化粧品、食品などさまざまな分野で取り入れられている生産形態です。OEMとは、「Original Equipment Manufacturer」の略語。

# 対策
* 日々の確認
  * ログ監視による不審なアクセス等がないかの確認
  * 製品ベンダより発信される情報の収集
* 平時の備え
  * 製品ベンダから発信された情報をもとに対応するための体制の整備
  * ゼロデイの脆弱性情報または、攻撃を確認した際の対応手順の整備
  * 整備した体制、対応手順が運用可能なものであるかの確認

# 事象例
[お知らせ: [至急]Proselfのゼロデイ脆弱性(CVE-2023-45727)による攻撃発生について(更新) / オンラインストレージ構築パッケージ Proself (プロセルフ) / 株式会社ノースグリッド](https://www.proself.jp/information/153/)
権限を用いないリモートユーザがファイル、ユーザ情報を読むことが可能だった。
XXE（XML External Entity）が原因。

[CWE - CWE-611: Improper Restriction of XML External Entity Reference (4.13)](https://cwe.mitre.org/data/definitions/611.html)
XMLに記述された`file:// URI`などを`file:///c:/winnt/win.ini`のようにしてローカルファイルを参照させてしまう脆弱性。（ディレクトリトラバーサルに近しい？）