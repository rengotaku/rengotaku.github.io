---
title: "[Conoha]CentOSサーバのセットアップ"
tags: ["linux", "centos", "conoha"]
---

**参考**
[conoha vpsで最初にやること](https://note.com/mocotech/n/n5df22097b965)

**前提**
V3のコンソールでサーバを作成してます。


## ユーザ作成
webのコンソールよりrootログインする。

`$ adduser admin`
`--disabled-password`はオプションが存在しなかった

**パスワードなしでsudoを可能**
```
$ visudo
admin ALL=(ALL) NOPASSWD: ALL
```

## sshログインする
**フォルダなどを作成**

```
$ su - admin
$ mkdir ~/.ssh
$ chmod 700 ~/.ssh
$ vi ~/.ssh/authorized_keys # 特殊キー、テキスト送信を利用して頑張って貼り付ける
$ chmod 600 ~/.ssh/authorized_keys
```

**接続確認**
手持ちのPCより。
`$ ssh admin@xxx.xxx.xxx.xxx -i ~/.ssh/publickey`

※接続できないと感じたら、セキュリティグループを確認して`デフォルト`だったら、`IPv4v6-SSH`を追加しましょう。

## etckeeperのインストールと設定
```
$ sudo yum update && sudo yum install epel-release && sudo yum install etckeeper
```

設定は下記のStep 2〜4を参照
[How To Manage /etc with Version Control Using Etckeeper on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-manage-etc-with-version-control-using-etckeeper-on-centos-7)

※ git操作する際は`sudo`をつけるのをお忘れずに

## sshの設定
```
$ vi /etc/ssh/sshd_config
# 下記の通りに設定
# PasswordAuthentication no
# PermitRootLogin prohibit-password
# PubkeyAuthentication yes

$ sudo systemctl restart sshd
```

