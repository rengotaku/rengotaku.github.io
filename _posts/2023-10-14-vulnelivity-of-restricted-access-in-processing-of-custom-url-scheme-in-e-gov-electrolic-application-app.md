---
title: "e-Gov電子申請アプリケーションにおける Custom URL Scheme の処理にアクセス制限不備の脆弱性 を読んで"
tags: ["vulnelibity", "security"]
---

[JVN#15808274: e-Gov電子申請アプリケーションにおける Custom URL Scheme の処理にアクセス制限不備の脆弱性](https://jvn.jp/jp/JVN15808274/index.html)
*保有する機能*
デジタル庁が提供する e-Gov電子申請アプリケーションをインストールすると、システムに Custom URL Scheme が登録され、Web ブラウザなどから特定の URL にアクセスすることで当該アプリケーションが起動されるようになります。

*問題*
このとき使用される URL には当該アプリケーションがアクセスする Web サイトの情報が含まれており、細工されたURLから当該アプリケーションを起動すると、想定されていない Web サイトにアクセスさせられる可能性があります [CWE-939](https://cwe.mitre.org/data/definitions/939.html)。

# 推測する事象
`appscheme://openwebsite?url=http%3A%2F%2Fexample.com`をアプリケーションで利用できたとする。
* `openwebsite`はクエリで指定されたWebサイトを表示する処理のハンドラーキー。
* `url`は表示するWebサイトのURL。

https://kokoha-warui-website.com なる悪徳サイトにアクセスして、上記のURLを押下すると、
e-Gov電子申請アプリケーションが表示され、アプリケーション内部のWeb Viewに悪徳Webサイトが表示される。
ユーザは国のアプリケーションで開かれているWebサイトなので安心してしまい個人情報などを入力してしまう。
