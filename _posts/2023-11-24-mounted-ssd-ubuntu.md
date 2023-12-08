---
title: "[Ubuntu]SSDをマウントする"
tags: ["ssd", "ubuntu", "linux"]
---

# 外付けSSDをマウントする
[NanoPC-T6 - FriendlyELEC WiKi](https://wiki.friendlyelec.com/wiki/index.php/NanoPC-T6#Connect_NVME_SSD_High_Speed_Hard_Disk)

## SSDの認識していることの確認
```
$ cat /proc/partitions
major minor  #blocks  name
...
   8        0  468851544 sda
```

## パーティションの作成
`$ (echo g; echo n; echo p; echo 1; echo ""; echo ""; echo w; echo q) | fdisk /dev/sda`

**パーティションを確認**
```
$ cat /proc/partitions
major minor  #blocks  name
...
   8        0  468851544 sda
   8        1  468850503 sda1
```

## ext4でフォーマット
`$ mkfs.ext4 /dev/sda1`

## 自動起動の設定
**SSDのUUIDを確認**
後のmount設定で`/dev/sda1`とパスを指定しても良いがUUIDがベターらしい。
```
$ sudo blkid /dev/sda1
/dev/sda1: UUID="e00b0ada-a938-46db-a1c3-fc4390e75fc8" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="644ab261-2a0d-7542-990f-8aa3f63c9e4c"
```

**マウント情報を記入する**
```
$ cat /etc/fstab
# UNCONFIGURED FSTAB FOR BASE SYSTEM
UUID=e00b0ada-a938-46db-a1c3-fc4390e75fc8 /mnt/ssd1 ext4 defaults 0 0
```

**マウント先のフォルダを作成**
```
$ mkdir -p /mnt/ssd1
$ chmod 777 /mnt/ssd1
```

**マウントする**
```
mount /mnt/ssd1
```

マウントが正しく行われるとシステムでも認識してくれる。
再起動をかけても同様にマウントした状態になる。
```
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
...
/dev/sda1       440G   28K  417G   1% /mnt/ssd1
```

※ `mount`コマンド時にエラーが出力されないことに注意してください。フォーマット形式が正しくない旨のエラーが出たまま再起動したら、正常に立ち上がらなくなりました。