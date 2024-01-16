---
title: "Setting up SAMBA in Linux server"
tags: ["smb"]
---

[Mount an SMB Share in Linux - Linode Docs](https://www.linode.com/docs/guides/linux-mount-smb-share/)

# How to up SMB
[Install and Configure Samba | Ubuntu](https://ubuntu.com/tutorials/install-and-configure-samba#1-overview)

## Installing Samba
```
$ sudo apt update
$ sudo apt install samba
```

```
$ whereis samba
samba: /usr/sbin/samba /usr/lib/aarch64-linux-gnu/samba /etc/samba /usr/share/samba /usr/share/man/man7/samba.7.gz /usr/share/man/man8/samba.8.gz
```

## Setting up Samba
```
$ sudo adduser sambauser
$ mkdir /home/sambauser/sambashare
```

```
$ sudo vi /etc/samba/smb.conf
$ tail -10 /etc/samba/smb.conf
# Please note that you also need to set appropriate Unix permissions
# to the drivers directory for these users to have write rights in it
;   write list = root, @lpadmin

[sambashare]
    comment = Samba on Ubuntu
    path = /home/sambauser/sambashare
    read only = no
    browsable = yes
    guest ok = no
```

```
$ sudo service smbd restart
```

## Setting up User Accounts and Connecting to Share
```
sudo smbpasswd -a sambauser
```

## Connecting to Samba from MacOS
Kick Finder then, selected `Go -> Connect to Server`

```
smb://youripaddress/sambashare
```

# Tips
## If you can't upload any files
Find out folder's owner property.
```
$ ll -d /home/sambauser/sambashare
drwxr-xr-x 2 sambauser sambauser 4096 Dec 29 03:55 /home/sambauser/sambashare/
```

## Attaching NAS on Linux

```
$ sudo yum install cifs-utils
$ sudo mkdir /mnt/vpnshare
$ sudo mount -t cifs -o "username=sambauser,password=xxxx,uid=$(id -u),gid=$(id -g),forceuid,forcegid" //127.0.0.1/sambashare /mnt/vpnshare
```

And then via ssh tunnel
```
# ssh -f -N -L 445:127.0.0.1:445 nanopc
```
