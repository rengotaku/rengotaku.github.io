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

```
Welcome to fdisk (util-linux 2.37.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x78093b8e.

Command (m for help): Created a new GPT disklabel (GUID: B8CB6E8E-76AE-E94B-A6A4-7EC96723002B).

Command (m for help): Partition number (1-128, default 1): Value out of range.
Partition number (1-128, default 1): First sector (2048-1953525134, default 2048): Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-1953525134, default 1953525134):
Created a new partition 1 of type 'Linux filesystem' and of size 931.5 GiB.

Command (m for help): The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

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

```
$ sudo mkfs.ext4 /dev/sdb1
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done
Creating filesystem with 244190385 4k blocks and 61054976 inodes
Filesystem UUID: a9915c57-4e14-4b26-9628-2ffffd432715
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
	102400000, 214990848

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done
```

## 自動起動の設定
**SSDのUUIDを確認**
後のmount設定で`/dev/sda1`とパスを指定しても良いがUUIDがベターらしい。
```
$ sudo blkid /dev/sda1
/dev/sda1: UUID="e00b0ada-a938-46db-a1c3-fc4390e75fc8" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="644ab261-2a0d-7542-990f-8aa3f63c9e4c"
```

**マウント情報を記入する**
`/etc/fstab`を記入
```
$ cat /etc/fstab
# UNCONFIGURED FSTAB FOR BASE SYSTEM
UUID=e00b0ada-a938-46db-a1c3-fc4390e75fc8 /mnt/ssd1 ext4 defaults 0 0
```

**マウント先のフォルダを作成**
```
$ sudo mkdir -p /mnt/ssd1
$ sudo chmod 777 /mnt/ssd1
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