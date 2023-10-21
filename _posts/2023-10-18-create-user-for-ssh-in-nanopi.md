---
title: "NanopiにSSH用のユーザを作成する"
tags: ["linux"]
---

[How to Add User to Sudoers in Ubuntu | Linuxize](https://linuxize.com/post/how-to-add-user-to-sudoers-in-ubuntu/)
[Allow Or Deny SSH Access To A Particular User Or Group In Linux](https://ostechnix.com/allow-deny-ssh-access-particular-user-group-linux/)
[Linux Delete user password command - nixCraft](https://www.cyberciti.biz/faq/linux-delete-user-password/)

# ユーザ作成
```
$ useradd remoteuser
$ passwd --delete remoteuser
$ usermod -aG sudo remoteuser
```

# SSHの接続制限
```
$ sudo vi /etc/ssh/sshd_config
AllowUsers remoteuser # piユーザはsshさせない
```

# SSHで接続時に実行するスクリプト
```
$ cp /home/pi/.bashrc /home/remoteuser/.bashrc
$ sudo vi /etc/passwd
remoteuser:x:1001:1001::/home/remoteuser:/bin/bash # /bin/sh だと bashrcが読み込まれないため
```