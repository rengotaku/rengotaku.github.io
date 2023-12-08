---
title: "SSHの公開鍵を登録するコマンド"
tags: ["ssh", "linux"]
---

[ssh-copy-idで公開鍵を渡す - Qiita](https://qiita.com/kentarosasaki/items/aa319e735a0b9660f1f0)

```
$ ssh-copy-id -i ~/.ssh/id_ed25519_lan.pub pi@192.168.2.50
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/username/.ssh/id_ed25519_lan.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
pi@192.168.2.50's password:

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'pi@192.168.2.50'"
and check to make sure that only the key(s) you wanted were added.
```

**注意**
ユーザのパスワード認証は求められる。ユーザにパスワードを設定していない場合でも。

ssh-copy-id で行なっているのは
[security - ssh-copy-id without authentication - Ask Ubuntu](https://askubuntu.com/a/1009687)
```
scp ~/.ssh/id_ed25519_lan.pub pi@192.168.2.50:
ssh pi@192.168.2.50 'cat id_rsa.pub >> .ssh/authorized_keys'
ssh pi@192.168.2.50 'rm ~/.ssh/id_ed25519_lan.pub'
```