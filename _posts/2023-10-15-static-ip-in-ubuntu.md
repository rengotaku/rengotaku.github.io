---
title: "Ubuntuで固定IPを設定する"
tags: ["ubuntu", "network"]
---

[Setting a Static IP in Ubuntu – Linux IP Address Tutorial](https://www.freecodecamp.org/news/setting-a-static-ip-in-ubuntu-linux-ip-address-tutorial/)

DHCPで割り振られているIPの設定を確認する。
```
$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.2.238  netmask 255.255.255.0  broadcast 192.168.2.255
[...]
```

今回指定したいIPは、`192.168.2.20`で設定する。
`192.168.2.1`は（DHCPでIPを割り振っている）ルータのIPです。
```
$ cat /etc/netplan/99_config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: false
      addresses: [192.168.2.20/24]
      gateway4: 192.168.2.1
      nameservers:
        addresses: [8.8.8.8,8.8.8.4]
```

`netplan try`で一見問題なく反映されているように見えますが、`ifconfig`でIPを確認しても変更されていません。
```
$ sudo netplan try
Do you want to keep these settings?


Press ENTER before the timeout to accept the new configuration


Changes will revert in 114 seconds
Configuration accepted.
```

`netplan --debu apply`を実行すると、`WARNING:Falling back to a hard restart of systemd-networkd.service`なるエラーが発生します。
```
$ sudo netplan --debu apply
** (generate:2077): DEBUG: 21:21:56.826: starting new processing pass

** (generate:2077): WARNING **: 21:21:56.827: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.
** (generate:2077): DEBUG: 21:21:56.827: We have some netdefs, pass them through a final round of validation
** (generate:2077): DEBUG: 21:21:56.827: eth0: setting default backend to 1
** (generate:2077): DEBUG: 21:21:56.827: Configuration is valid
** (generate:2077): DEBUG: 21:21:56.828: Generating output files..
** (generate:2077): DEBUG: 21:21:56.829: openvswitch: definition eth0 is not for us (backend 1)
** (generate:2077): DEBUG: 21:21:56.829: NetworkManager: definition eth0 is not for us (backend 1)
DEBUG:netplan generated networkd configuration changed, reloading networkd
** (process:2075): DEBUG: 21:21:57.120: starting new processing pass

** (process:2075): WARNING **: 21:21:57.121: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.
** (process:2075): DEBUG: 21:21:57.121: We have some netdefs, pass them through a final round of validation
** (process:2075): DEBUG: 21:21:57.121: eth0: setting default backend to 1
** (process:2075): DEBUG: 21:21:57.122: Configuration is valid
DEBUG:Merged config:
b''
DEBUG:no netplan generated NM configuration exists
** (process:2075): DEBUG: 21:21:57.138: starting new processing pass

** (process:2075): WARNING **: 21:21:57.138: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.
** (process:2075): DEBUG: 21:21:57.138: We have some netdefs, pass them through a final round of validation
** (process:2075): DEBUG: 21:21:57.138: eth0: setting default backend to 1
** (process:2075): DEBUG: 21:21:57.138: Configuration is valid
DEBUG:Merged config:
b''
DEBUG:Link changes: {}
DEBUG:netplan triggering .link rules for lo
DEBUG:netplan triggering .link rules for eth0
DEBUG:netplan triggering .link rules for eth1
** (process:2075): DEBUG: 21:21:57.490: starting new processing pass

** (process:2075): WARNING **: 21:21:57.490: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.
** (process:2075): DEBUG: 21:21:57.490: We have some netdefs, pass them through a final round of validation
** (process:2075): DEBUG: 21:21:57.491: eth0: setting default backend to 1
** (process:2075): DEBUG: 21:21:57.491: Configuration is valid
** (process:2075): DEBUG: 21:21:57.491: starting new processing pass

** (process:2075): WARNING **: 21:21:57.491: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.
** (process:2075): DEBUG: 21:21:57.492: We have some netdefs, pass them through a final round of validation
** (process:2075): DEBUG: 21:21:57.492: eth0: setting default backend to 1
** (process:2075): DEBUG: 21:21:57.492: Configuration is valid
DEBUG:Merged config:
b''
WARNING: systemd-networkd is not running, output will be incomplete.

Failed to reload network settings: No such file or directory
WARNING:Falling back to a hard restart of systemd-networkd.service
```

[Ubuntu Linux で LAN アダプターの MTU を設定する](https://ez-net.jp/article/BB/OZN_4CRI/VoaK4gh1NeXG/)
より`Falling back to a hard restart of systemd-networkd.service`のエラーが出たら、applyをもう一度実行する（不思議なことに解決する）
