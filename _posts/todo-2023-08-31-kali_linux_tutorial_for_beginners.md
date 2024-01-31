---
title: "Kali Linux Tutorial For Beginners をみて"
tags: ["kalilinux"]
---

[Kali Linux Tutorial For Beginners | Udemy](https://www.udemy.com/course/kali-linux-tutorial-for-beginners/learn/lecture/7931378#overview)

Section4 は基本的な操作すぎて見なくても良い

* 38. Networking basics on Kali Linux
  * eth0 - Wired network
  * lo - loopback address
  * wlan0 - Wireless network
  * You can show default gate way server's IP belows:
    * `nslookup google.com` looks like is Server
    * `cat /etc/resolve.conf` looks like nameserver IP
    * `ip route`
    * `traceroute hackerscademy.com` looks like gateway
  * `netstat -antp` can shwo runnning services on the host.
    * -a: all, -n: show numerical address, -t: TCP, -p: show the name of the program
