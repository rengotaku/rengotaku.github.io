---
title: "Linuxのログローテートのデバッグ"
tags: ["linux", "logrotate"]
---

[How to Configure Logrotate to Manage Logfiles (Step by Step)](https://adamtheautomator.com/logrotate-linux/) を参考に。

# 設定

ログレートの設定ファイルを設定する
```
$ cat /etc/logrotate.d/rails_app
/var/www/rails/staging/current/log/*.log {
  weekly
  rotate 10
  copytruncate
  missingok
  notifempty
  compress
  delaycompress
  dateext
  dateformat -%d%m%Y
}
```
※ [logrotateのcopytruncateによる記入漏れ検証 – 株式会社ルーター](https://rooter.jp/data-format/omission_of_logrotate_copytruncate/) に指定の意味が記載あり

指定のフォルダの配下
```
$ ll /var/www/rails/staging/current/log/
[...]
-rw-rw-r-- 1 ubuntu ubuntu        884 Sep 15 18:25 development.log
[...]
```

実行されると...

```
-rw-rw-r-- 1 ubuntu ubuntu          0 Sep 15 18:26 development.log
-rw-rw-r-- 1 ubuntu ubuntu        884 Sep 15 18:26 development.log-15092023
```

# チップス
* create と copytruncate の違い
  * [How to Manage Log Files Using Logrotate | Datadog](https://www.datadoghq.com/blog/log-file-control-with-logrotate/#create-or-copy-log-files-to-manage-rotation)
  * 片方しか設定できない。たまに記事で両方を設定している人がいる。
  * truncateだとファイルを利用中のプロセス(Rails)を再起動しなくて良いのでこの設定
* データフォーマット
  * weeklyではなく、`hourly`を指定した際にdateformatを書き換えるか削除する。`-%d%m%Y`のままだと、上手くローテートされない

**デバッグの仕方**
ステータスファイルを作成する。
※日付はローテートが実行される範囲を空けた過去の日付を設定する
```
$ cat /var/lib/logrotate.status
logrotate state -- version 2
"/var/www/rails/staging/current/log/development.log" 2023-8-15-18:0:0
```

logrotateコマンドで検証します。
オプション: sは利用するステータスファイル は、vはverbose、dはdry-run

ローテートが実行される場合
```
$ sudo logrotate -s /var/lib/logrotate.status /etc/logrotate.conf -vd
[...]
rotating log /var/www/rails/staging/current/log/development.log, log->rotateCount is 10
Converted ' -%d%m%Y' -> '-%d%m%Y'
dateext suffix '-15092023'
glob pattern '-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
glob finding logs to compress failed
glob finding old rotated logs failed
copying /var/www/rails/staging/current/log/development.log to /var/www/rails/staging/current/log/development.log-15092023
truncating /var/www/rails/staging/current/log/development.log
switching euid to 0 and egid to 0
[...]
```

ローテートの実行対象外の場合
```
  Now: 2023-09-15 18:26
  Last rotated at 2023-09-15 18:00
  log does not need rotating (log has been already rotated)
```
