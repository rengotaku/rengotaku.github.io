---
title: "BundlerでgemをインストールしようとするとOpenSSL系でエラーが発生する"
tags: ["bundler", "gem", "ruby"]
---

## 経緯
OpenSSL系のエラーが原因で `bundle install` に失敗しており、解消に時間がかかっている。
原因は別でRuby（バージョン3）をOpenSSL3系を指定してインストールし、色々ごにょっていた時に少し壊れた可能性が高い。

Ruby2.7とOpenSSL3系の互換性が悪いらしく、一旦OpenSSL@1.1で設定しなおしました。

## エラー内容(bundle install時)

```
OpenSSL::X509::StoreError: system lib
  /Users/hoge/.rbenv/versions/2.7.6/lib/ruby/gems/2.7.0/gems/bundler-2.4.22/lib/bundler/fetcher.rb:304:in `add_file'
...
```

## 確認内容

1. 証明書の期限は問題なし（最新に更新済み）

```
$ openssl s_client -connect example.com:443 < /dev/null 2> /dev/null | openssl x509 -text | grep Not

Not Before: Jan 30 00:00:00 2024 GMT
Not After : Mar  1 23:59:59 2025 GMT
```

2. Rubyはopenssl@1.1で再インストール済み

```
require 'openssl'
puts OpenSSL::OPENSSL_VERSION
puts OpenSSL::Config::DEFAULT_CONFIG_FILE

↓実行結果
OpenSSL 1.1.1w  11 Sep 2023
/usr/local/etc/openssl@1.1/openssl.cnf
```

3. Ruby側はシステムの証明書を見ている

```
$ ruby -ropenssl -e 'p OpenSSL::X509::DEFAULT_CERT_FILE'

"/usr/local/etc/openssl@1.1/cert.pem"
```

4. 環境変数でシステムのSSLを見に行くように設定している

```
$ ENV | grep SSL

SSL_CERT_FILE=/usr/local/etc/openssl@1.1/cert.pem
SSL_CERT_DIR=/usr/local/etc/openssl@1.1/certs
```

5. bundle configにopenssl@1.1のパスを指定

```
$ bundle config

cacert.pem
Set for your local app (/Users/hoge/git/hogehoge/.bundle/config): "/usr/local/etc/openssl@1.1/cert.pem"

path
Set for your local app (/Users/hoge/git/hogehoge/.bundle/config): ".bundle"
Set for the current user (/Users/hoge/.bundle/config): "vendor/bundle"

ssl_ca_cert
Set for the current user (/Users/hoge/.bundle/config): "/usr/local/share/ca-certificates/Fortinet/Fortinet_CA_SSLProxy.crt"

system_ca_path
Set for the current user (/Users/hoge/.bundle/config): "/usr/local/etc/openssl@1.1/cert.pem"
```

別環境でのチェック

```
$ openssl version
OpenSSL 1.1.1u  30 May 2023
$ irb
irb(main):001:0> require 'openssl'
=> true
irb(main):002:0> puts OpenSSL::OPENSSL_VERSION
OpenSSL 1.1.1t  7 Feb 2023
=> nil
irb(main):003:0> puts OpenSSL::Config::DEFAULT_CONFIG_FILE
/Users/userhoge/.rbenv/versions/2.7.6/openssl/ssl/openssl.cnf
=> nil
$ bundle config
Settings are listed in order of priority. The top value will be used.
build.mysql2
Set for your local app (/Users/userhoge/feature/.bundle/config): "--with-ldflags=-L/usr/local/opt/openssl/lib"

jobs
Set for your local app (/Users/userhoge/feature/.bundle/config): 4
```

## 原因
OpenSSL3系が入った際に、 bundle config に `ssl_ca_cert`の設定が入ってしまい、bundleのGemが証明書を見に行ってしまったのが原因。（ssl_ca_certの設定を除去すれば良い）

OpenSSL3を再インストールしても Fortinet_CA_SSLProxy.crt の証明書が入らないので気付けにくい。
