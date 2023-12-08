---
title: "SofteatherでVPNサーバーを立てる"
tags: ["softeather", "vpn"]
---

# 参考記事
## AWS EC2 でVPNサーバーを建てる | クロジカ
https://tech.kurojica.com/archives/56888/

* VPCの作成
* EC2サーバを作成
* SoftEtherのインストール
* サービス設定
* SoftEtherの設定
* VPNユーザーの追加
* クライアント設定(mac, Windows10)

### メモ

* やりたいことは非常に似ていそう（だけど下記の設定が、、、あれ？）
* `ExecStartPre=/sbin/ip link set dev eth0 promisc on`が指定されているが有効にならないのでは？
* `SecureNatEnable`を利用している？？？（社内ネットワークにでも利用しなければ不要だと思っていたが、、、）

## 急に発生した全社リモートワーク・テレワーク対応、その悩み、AWS+SoftEtherで解決できます！｜技術ブログ｜北海道札幌市・宮城県仙台市のVR・ゲーム・システム開発 インフィニットループ
`社内ネットワーク`へのアクセスなので要件はずれているが設定が参考になる。
https://www.infiniteloop.co.jp/tech-blog/2020/02/softethervpn-on-cloud/

* VPCの作成
* EC2サーバを作成
    * セキュリティグループ作成
* サーバミドルウェアのインストール
* SoftEtherのインストール
* SoftEtherの設定
* VPNユーザーの追加
* クライアント設定(Windows)

### メモ

* `AWSにSoftEther VPNServerで簡単にVPN接続しよう`を参考
* VPNユーザーの追加の永続化の仕方の記載あり
* 仮想HUBのデフォルトは削除している（具体的な理由は不明）

## AWS EC2(CentOS)でSoftEtherを用いたVPNを設定する - メタルドラマーのIT備忘録（IT memorandum by a metal drummer）
https://wellknowledge.org/ec2-softether/

* EC2サーバを作成
    * セキュリティグループ
* サーバミドルウェアのインストール
* SoftEtherのインストール
* サービス設定
* SoftEtherの設定
* クライアント設定(Windows)

### メモ
* 用途が同じに見える
* `/etc/init.d/vpnserver`は参考になりそう
* default hubを削除していない？
* SecureNatEnableしている

## EC2 に SoftEther VPN Server をインストールして AWS VPC 内のリソースに自宅から安全にアクセスする - Qiita
`VPCにセキュアに接続させるためなので用途が違いそう`
https://qiita.com/clerk67/items/d31504e786fe4f8f9acf

* SoftEtherのインストール
    * セキュリティグループがちらっと記載
* サーバミドルウェアのインストール
* サービス設定
* SoftEtherの設定
  * 細々と記載あり
* クライアント設定(Windows)

### メモ
* `AWSにSoftEther VPNServerで簡単にVPN接続しよう`を参考
* `promisc on`を利用している
* `SecureNatEnable`を設定している

## AWSにSoftEther VPNServerで簡単にVPN接続しよう | DevelopersIO
https://dev.classmethod.jp/articles/rk-2018-02-12-softethervpn/

* EC2サーバを作成
    * セキュリティグループ
* サーバミドルウェアのインストール
* サービス設定
* SoftEtherの設定
  * 細々と記載あり
* クライアント設定(Mac)

### メモ
* 複数の記事で参照されている
* https://qiita.com/neustrashimy/items/6fd9ddafc8ea6278f088 の記事から、`promisc on`の設定が引き継がれている模様。

## シンクリッジ - : 技術系備忘録/AWS/SoftEtherを使ってVPN接続
`リモートネットワークへのアクセス`が要件なのでずれている、かつ割愛が多め
https://thinkridge.com/modules/xpwiki/?%E6%8A%80%E8%A1%93%E7%B3%BB%E5%82%99%E5%BF%98%E9%8C%B2%2FAWS%2FSoftEther%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6VPN%E6%8E%A5%E7%B6%9A

* EC2サーバを作成
* SoftEtherのインストール
* サービス設定
* SoftEtherの設定（GUI）
* クライアント設定(具体的な説明なし)

メモ

* パブリックサブネットでパブリックIPを付与
* ローカルブリッジ設定は不可
    * 参考 [EC2にてローカルブリッジ接続が効かない - SoftEther VPN User Forum](https://forum.vpngate.net/viewtopic.php?t=64776)
* セキュアNATの有効化
    * 本件の要件では必要なさそう。`データセンターで稼働している PC 群にアクセスするような場合`とあるため、`PC->VPC->（Firewallで守られた）データセンター`が想定される。


## AWS上にVPNサーバを構築する | Happy Life Creators
`SoftEtherの設定がdockerに内包されていて設定は参考にならない`
https://www.happylifecreators.com/blog/20220606/

* Amazon Lightsailを作成（EC2ではなく）
* ポート解放
* Dockerコンテナ立ち上げ
    * https://hub.docker.com/r/siomiz/softethervpn/

メモ
> ということで、選択肢は「LT2P/IPsec」になりました
> さて、LT2P/IPsecといえば、OSSの「SoftEther VPN」ですね

> 試しにCMANのWebサイトにアクセスし、VPNサーバ経由のIPアドレスになっているかを確認しましょう
> https://www.cman.jp/network/support/go_access.cgi

# 設定
## Lightsaildeでインスタンス作成
* OSはUbuntu

### 細かな設定
* ポートに、UPD500、4500を追加
* IPv6は無効化

### SSH接続
```
$ chmod 600 LightsailDefaultKey-ap-northeast-1.pem
$  ssh -i LightsailDefaultKey-ap-northeast-1.pem ubuntu@xx.xx.xx.xx
```

### 事前設定
```
$ sudo timedatectl set-timezone Asia/Tokyo
```

## SoftEtherのインストール
```
$ sudo apt -y update
$ sudo apt -y install git gcc make
$ wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.41-9782-beta/softether-vpnserver-v4.41-9782-beta-2022.11.17-linux-x64-64bit.tar.gz
$ tar zxvf softether-vpnserver-v4.41-9782-beta-2022.11.17-linux-x64-64bit.tar.gz
$ cd vpnserver
$ make
$ cd ..
$ sudo mv vpnserver /opt/vpnserver
$ sudo vi /etc/systemd/system/vpnserver.service
```

`/etc/systemd/system/vpnserver.service`

```
[Unit]
Description=Softether VPN Server Service
After=network.target

[Service]
Type=forking
User=root
ExecStart=/opt/vpnserver/vpnserver start
ExecStop=/opt/vpnserver/vpnserver stop
Restart=on-abort
WorkingDirectory=/opt/vpnserver/

[Install]
WantedBy=multi-user.target
```

続き

```
$ sudo chmod 755 /etc/systemd/system/vpnserver.service
$ sudo systemctl daemon-reload
$ sudo systemctl start vpnserver
$ sudo systemctl enable vpnserver
```

## SoftEtherの起動

```
$ sudo /opt/vpnserver/vpncmd
```

## SoftEtherをコマンド実行
★の箇所を入力する
```
sudo /opt/vpnserver/vpncmd

1. Management of VPN Server or VPN Bridge
2. Management of VPN Client
3. Use of VPN Tools (certificate creation and Network Traffic Speed Test Tool)
Select 1, 2 or 3: 1 # ★

Hostname of IP Address of Destination: xx.xx.xx.xx # ★ServerIP

VPN Server>hubdelete # ★
HubDelete command - Delete Virtual Hub
Name of Virtual Hub to delete: DEFAULT # ★

VPN Server>HubCreate vpnhub # ★
Password: **** # ★
Confirm input: **** # ★

VPN Server>HUB vpnhub # ★

VPN Server/main>UserCreate test.user /Group:none /REALNAME:none /NOTE:none # ★

VPN Server/main>UserPasswordSet test.user # ★
Password: **** # ★
Confirm input: **** # ★

VPN Server/main>IPsecEnable /L2TP:yes /L2TPRAW:no /ETHERIP:no /DEFAULTHUB:vpnhub # ★

VPN Server/main>SecureNatEnable # ★

VPN Server/main>exit
```

## VPN接続する
MACでVPN接続の設定を行う。

`L2TP over IPSec`->`Send all trafic over VPN connection`を有効にしないとVPN経由して通信が行われないことに注意する