---
title: "ActiveRecordのbeginless rangeとendless range"
tags: ["rails", "activerecord"]
---

[【Rails】範囲オブジェクト(Range)を使ったActiveRecordのwhere比較、範囲検索のコードの書き方 - Simple minds think alike](https://simple-minds-think-alike.moritamorie.com/entry/active-record-where-with-range)

## Ruby2.7から導入されたbeginless range
範囲オブジェクトの開始の値を省略できる書き方

```
User.where(age: ..30)
SQL: SELECT "users".* FROM "users" WHERE "users"."age" <= 30"
```

## Ruby2.6から導入されたendless range
範囲オブジェクトの終わりの値を省略できる書き方

```
User.where(age: 11..)
SQL: SELECT "users".* FROM "users" WHERE "users"."age" >= 11"
```

## メリット
* コード量が少なく可読性が高い
* 保守面でのメリットが高い

**今までの書き方**
範囲オブジェクト使用: User.where(age: - Float::INFINITY..30)
範囲オブジェクト未使用: User.where('age < ?', 30)

範囲オブジェクトを使用しない場合、無駄がない書き方ではあるがテーブルを結合して両方のテーブルにある同じ名前のカラムを抽出条件にする場合、エラーになるというデメリットがある
