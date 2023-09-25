---
title: "NASサーバをNanoPiの上に立てる"
tags: ["nas", "linux", "nanopi"]
---

# 外付けSSDをマウントする
[【Linux】外付けストレージのフォーマット&マウント方法](https://zenn.dev/tochiman/articles/a3c4ace8e20874)

`fdisk /dev/sda`
`mount /dev/sda1 /mnt/ssd1`

[【ゼロから解説】Linuxのフォーマットの方法](https://eng-entrance.com/linux-format)
`mkfs -t ext4 /dev/sdb1`を行った方が良いかも。（上記の記事はSSDをフォーマットしている前提）

## マウントした先にアクセス可能なフォルダを作成
`mkdir /mnt/ssd1/share && chomod 777 /mnt/ssd1/share`を実行しておく。
MACからNASを参照できるけどアップロードできないようなことが権限問題で発生してしまう。

# LANポート側からNASを閲覧できるようにする
[NanoPi R4S SBC preview with OpenWrt and Ubuntu Core - CNX Software](https://www.cnx-software.com/2020/12/13/nanopi-r4s-sbc-preview-with-openwrt-and-ubuntu-core/)
`http://192.168.2.1/cgi-bin/luci/admin/network/network`(Network -> Interfaces) にて各種ポートの設定を確認します。
デフォルトだと、`lan: br-lan`に`Protocol: Static address`が設定してあるものが1つあると思う。
そちらを削除して、`ETH1: eth1`の`Protocol: DHCP client`に設定する。

※ WAN側はFirewallが色々と設定してありポートの穴の開け方が分からなかった。信頼できるネット内（DDNSなど外部からのアクセスを許していない）なので行っている。

# NASの設定
`http://192.168.2.1/cgi-bin/luci/admin/nas/samba4`(`NAS -> Network Shares`)を開く
`Enable macOS compatible shares`を有効にする（MACの場合）
`Shared Directories`に下記を追加する（残りの項目はデフォルトでOK）
* Name: nas
* Path: /mnt/ssd1

# NASサーバのあるNanoPiのIPを固定にする(ルーターがNanoPiの場合)
`http://192.168.2.1/cgi-bin/luci/admin/network/dhcp`にて、下記を設定し追加する。
* Hostname: FriendlyWrtR4S(わかりやすい名称)
* MAC address: CA:44:xx:xx
* IPv4 address: 192.168.2.10(適宜)

設定したらNASサーバのNanoPiのインターフェースを再起動してIPを再取得させる

# MACでアクセスする
[Ubuntu Server 21.04 に Samba サーバを立てて Mac とファイルを共有する - Qiita](https://qiita.com/hajime-f/items/b1cf3885b2a52d1298fe) を参考に。
`smb://192.168.2.10`で接続。
ゲストを選択。
shareフォルダ配下に画像などをアップロード。