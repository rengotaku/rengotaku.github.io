---
title: "モデルのデータをCSVで移送する方法"
tags: ["rails", "ruby"]
---

## 関連資料
[Rails 6.1 adds values_at attribute method for Active Record - BigBinary Blog](https://www.bigbinary.com/blog/rails-6-1-adds-values_at-attribute-method-for-active-record)

[Ruby - Array zip() function - GeeksforGeeks](https://www.geeksforgeeks.org/ruby-array-zip-function/)

## 前提
モデルのデータを別環境に移送する際にCSVを利用する。
その際のシリアライズ、デシリアライズに利用できそうな手法。

## コード
サンプルだと`columns_data`は配列だが適宜、カンマ区切り文字列などに加工して扱う。
zipに渡す前に漏れなく配列オブジェクトにデシリアライズしておく必要あり。

```
pry(main)> columns_data = User.first.values_at(User.column_names)
=> [1, "test@example.com", "password", nil, nil]

pry(main)> User.column_names.zip(columns_data).to_h
=> {"id"=>1, "email"=>"test@example.com", "encrypted_password"=>"password", "reset_password_token"=>nil, "reset_passworded_at"=>nil}
```

## Tips

**Rails 6.1以前のvalues_at**

書き方が違う。

```
>> user.attributes.values_at("first_name", "full_name")
=> ["Era", nil]
```
