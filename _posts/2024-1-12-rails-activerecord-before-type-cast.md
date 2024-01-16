---
title: "ActiveRecord::AttributeMethods::BeforeTypeCast モジュール"
tags: ["rails", "activerecord"]
---

[ActiveRecord::AttributeMethods::BeforeTypeCast](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/BeforeTypeCast.html)

ActiveRecordでオブジェクトを作成すると
DBスキーマの情報に合わせて値が変換されるようになっている

## 例1: 日付を文字列でnewした場合
```
user = User.new(updated_at: “2012-10-21”)
user.updated_at => Sun, 21 Oct 2012
```

## 例2: BigDecimal型で小数点第3位までしか許容していないカラムの場合
```
user = User.new(score: 20.0001)
user.score #=> 20.000
※20.0001 という入力値は 20.000 に変換されてしまう
```

## ActiveRecord::AttributeMethods::BeforeTypeCast モジュールのメソッドを使うと
変換前の入力値を取得できる。変換前の純粋な入力値でバリデーションしたい場合などに便利。

例1の場合: user.updated_at_before_type_cast #=> “2012-10-21”
例2の場合: user.score_before_type_cast #=> 20.0001
