---
title: "[AWS]MySQLのバージョンを5.7から8系にあげる"
tags: ["aws", "mysql"]
---

# アプリケーションの修正
[MySQL :: MySQL 8.0 リファレンスマニュアル :: 8.2.1.16 ORDER BY の最適化](https://dev.mysql.com/doc/refman/8.0/ja/order-by-optimization.html)

> 以前は (MySQL 5.7 以下)、GROUP BY は特定の条件下で暗黙的にソートされていました。 MySQL 8.0 では発生しなくなったため、暗黙的ソートを抑制するために最後に ORDER BY NULL を指定する必要はなくなりました (前述のとおり)。 ただし、クエリー結果は以前の MySQL バージョンとは異なる場合があります。 特定のソート順序を生成するには、ORDER BY 句を指定します。

**BEFORE**
```
SELECT
    node_id,
...
GROUP BY node_id
ORDER BY position
```

**AFTER**
暗黙的にソートされていた`node_id`を指定した。
```
SELECT
    node_id,
...
GROUP BY node_id
ORDER BY position, node_id
```

# Terraformの修正

[RDSのBlue/Green デプロイメントを試してみた。 | DevelopersIO](https://dev.classmethod.jp/articles/rds-blue-green-deployment/) を利用することにより、Terraformに記載しているRDSの内容がすごく書き換わる。そのため、管理から一時的に除外する対応をした。