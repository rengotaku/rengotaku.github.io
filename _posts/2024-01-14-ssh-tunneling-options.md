---
title: "SSHトンネル接続のイロハ"
tags: ["linux", "ssh"]
---

[What is SSH Tunnel, SSH Reverse Tunnel and SSH Port Forwarding?](https://goteleport.com/blog/ssh-tunneling-explained/)

# SSHトンネルとは？
SSHセッションを利用してデータを転送する手法。
インターネットへポートを開放することなく、セキュアにリモートサーバにアクセスできるようにする。

# Local port forwarding
クライアントサーバの特定のポートを経由してデータをリモートサーバに転送する。`-L`オプションを利用する。

## 単体のポート
```
$ ssh -L 3306:127.0.0.1:3306 user@<remote_db_server>
```
`3306(クライアント)`ポート、`127.0.0.1(クライアント)`を、`3306(リモート)`ポートに転送する。接続先は`user@<remote_db_server>(リモート)`となる。

※クライアントとは`ssh`コマンドを実行したサーバ、リモートとは接続先サーバを指す。

## 複数のポート
```
$ ssh -L 3306:localhost:3306 -L 3307:localhost:3307 user@<remote_server>
```

## Tips
### 127.0.0.1以外からSSHトンネルを利用する場合
Mac内にDockerを立ている（ホスト内にネットワークを作成している）場合。Dockerコンテナ内部から、ホスト(Mac)でSSHでフォーワードしているポートに接続したい場合は、接続元を指定しない設定(`0.0.0.0`)が必要になる。
```
$ ssh -L 0.0.0.0:3306:127.0.0.1:3306 user@<remote_db_server>
```

### インタラクティブセッションの無効化
インタラクティブセッションを無効化にするために`-N`オプションを付与した方が良い。
```
$ ssh -N -L 0.0.0.0:3306:127.0.0.1:3306 user@<remote_db_server>
```

下記でインタラクティブセッションで接続できる。通常では利用しない。（デバッグで用いる？）
`$ ssh -t user@<remote_db_server> 'echo foo; exec zsh'`

# Remote port forwarding (reverse tunneling)
リモートサーバのデータをクライアントサーバに転送する。`-R`オプションを利用する。

```
$ ssh -R 80:127.0.0.1:3000 user@<remote_server_ip>
```
`3306(リモート)`ポート、`127.0.0.1(リモート)`を、`3306(クライアント)`ポートに転送する。接続先は`user@<remote_db_server>(リモート)`となる。

## Tips
### ローカルホストではなくパブリックIFに転送させたい
sshd_config内を`GatewayPorts yes`に書き換える。

# Dynamic port forwarding
クライアントサーバの指定ないポートを利用してデータをリモートサーバに転送する。`-D`オプションを利用する。

```
$ ssh -D 127.0.0.1:6000 user@<remote_server>
```
`全ての(クライアント)`ポート、`127.0.0.1(クライアント)`を、`6000(リモート)`ポートに転送する。接続先は`user@<remote_db_server>(リモート)`となる。

