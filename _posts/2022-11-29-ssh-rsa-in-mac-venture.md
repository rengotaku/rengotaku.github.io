---
title: "SSH connecting error in MacOS Ventura"
tags: ["mac", "sshd"]
---

# Problem
I tried to connect a server, but that refused and responded message `Permission denied`.
```
$ ssh -V
OpenSSH_6.2p2, OpenSSL 1.0.1k-fips 8 Jan 2015
```
If you updated your MacOS Ventura, you shouldn't be able to connect a server which has less than OpenSSH version 7.2 because of some changing around SSH.

# Solution
Enable ssh-rsa, if you use configration file of ssh, appending as below:
```
Host *
  HostkeyAlgorithms +ssh-rsa
  PubkeyAcceptedAlgorithms +ssh-rsa
```

# References
[Git SSH "permission denied" in macOS 13 Ventura - Super User](https://superuser.com/questions/1749364/git-ssh-permission-denied-in-macos-13-ventura)