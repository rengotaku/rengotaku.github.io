---
title: "[Ruby]delegateメソッドの使い方"
tags: ["ruby"]
---

## 概要
`Module#delegate`
このメソッドを使うことで癒着を弱めてデメテルの法則に沿えるようになる

**デメテルの法則**
任意のオブジェクトが自分以外の構造やプロパティに対して持っている仮定を最小限にすべきであるという考え方。
以下のように、objAから他のオブジェクトを経由してメソッドやオブジェクトなどを呼び出してはいけない。
objA.objB.Method()
→オブジェクト間のやりとりを最小限に抑え、必要であれば直接やりとりをする
`メリット: メンテナンスしやすくなる`

## メソッドの使用方法
モデルで以下のように指定
```
class Company < ApplicationRecord
  belongs_to :owner_user
  delegate :email, to: :owner_user
end
```

**呼び出し方**
company.email # company.owner_user.emailと同等

ちなみに以下の形で書くのと同等になるが、delegate を使った方がより簡潔に書ける
```
def name
  profile.name
end
```

**オプション**
・allow_nilオプションをつけるとowner_userがnilだった場合に例外ではなくnilを返すようにできる
`delegate :email, to: :owner_user, allow_nil: true`

上記は以下と同義
```
def name
  profile&.name
end
```

・prefixオプションでプレフィックスをつけることができる
`delegate :email, to: :owner_user, prefix: true`

呼び出し
`company.owner_user_email`

# 参考
[Active Support コア拡張機能 - Railsガイド](https://railsguides.jp/active_support_core_extensions.html#%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%81%AE%E5%A7%94%E8%AD%B2)
[デメテルの法則 - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%87%E3%83%A1%E3%83%86%E3%83%AB%E3%81%AE%E6%B3%95%E5%89%87)
[Rails Best Practices - the Law of Demeter](https://rails-bestpractices.com/posts/2010/07/24/the-law-of-demeter/)

