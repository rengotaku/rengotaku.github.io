---
title: "EC2のボリュームを増やす"
tags: ["aws", "ec2"]
---

https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ebs-modify-volume.html

# 事前確認
* ボリュームサイズ: 100 -> 200
* 対象のインスタンス: `r5.large`
* 現行世代のインスタンスか？: No
  * https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/instance-types.html#current-gen-instances より
* 現行世代のインスタンスか？: No
* Nitro or Xen か?: Nitro
  * [インスタンスタイプ - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/instance-types.html#ec2-nitro-instances) より
* FileSystemの種類: `ext4`

# 作業
## 適用前確認
```
ubuntu@xxx:~$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0   100G  0 disk
└─nvme0n1p1 259:1    0   100G  0 part /
```

```
ubuntu@xxx:~$ df -hT
Filesystem     Type      Size  Used Avail Use% Mounted on
/dev/nvme0n1p1 ext4       97G   90G  7.0G  93% /
```

## ステータスチェック(オプショナル)
心配性なので検証中に異常が発生してないかチェックする。
1秒毎にシステムにアクセスしてダウンの有無を確認。(最大1秒`-m 1`で接続を切ります)
```
while sleep 0.1; do
  echo "`date "+%T"` `curl -Ls -o /dev/null -w "%{http_code}" -m 1 https://example.com/`" >> http_statuses.log;
done
```

## スナップショットの作成
[Amazon EBS スナップショットの作成 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ebs-creating-snapshot.html)
Description、Tagsを適宜設定。
念の為の作業らしい。（今回は利用していない）

## ボリュームの変更
[EBS ボリュームへの変更のリクエスト - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/requesting-ebs-volume-modifications.html)
サイズを新しい値に変更する（今回は200）

適用すると、ボリュームのステータスが、`In-use - modifying (0%)` → `In-use - optimizing (0%)`と変わる。数分は必要。
完了してなくても、lsblkの状態は変わっている。（拡張するコマンドを実行しないと実際には適用されていない）
```
ubuntu@xxx:~$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0   200G  0 disk
└─nvme0n1p1 259:1    0   100G  0 part /
```

最終的には`In-use`のみになる。

## 拡張手続き
### パーティションを拡張
後続はパラメーターはパーティション番号。一つ目のため`1`
```
ubuntu@xxx:~$ sudo growpart /dev/nvme0n1 1
CHANGED: partition=1 start=2048 old: size=209713119 end=209715167 new: size=419428319 end=419430367
```

**状態**
```
ubuntu@xxx:~$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0   200G  0 disk
└─nvme0n1p1 259:1    0   200G  0 part /
```

### ファイルシステムを拡張
```
ubuntu@xxx:~$ sudo resize2fs /dev/nvme0n1p1
resize2fs 1.45.5 (07-Jan-2020)
Filesystem at /dev/nvme0n1p1 is mounted on /; on-line resizing required
old_desc_blocks = 13, new_desc_blocks = 25
The filesystem on /dev/nvme0n1p1 is now 52428539 (4k) blocks long.

ubuntu@xxx:~$ df -hT
Filesystem     Type      Size  Used Avail Use% Mounted on
/dev/nvme0n1p1 ext4      194G   90G  104G  47% /
```