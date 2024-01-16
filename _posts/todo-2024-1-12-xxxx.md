---
title: "GitHub、1200台以上のMySQL 5.7を8.0へアップグレード。サービス無停止のまま成功させる を読んで"
tags: ["rails", "activerecord"]
---

[GitHub、1200台以上のMySQL 5.7を8.0へアップグレード。サービス無停止のまま成功させる － Publickey](https://www.publickey1.jp/blog/23/github1200mysql_5780.html)

# 目的
GitHub.comを支える1200台以上のMySQL 5.7を、GitHub.comのサービスレベルを維持したままMySQL 8.0にアップグレードした。
期間は1年以上。

# 状況
MySQLサーバはMicrosoft Azure上の仮想マシンやベアメタルサーバによる1200台以上のホストで稼働し、1つのプライマリと複数のレプリカからなる50以上のクラスタ構成によって高可用性と高性能を実現しています。

TODO
