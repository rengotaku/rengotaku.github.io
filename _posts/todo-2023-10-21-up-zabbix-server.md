---
title: "Zabbix serverをdocker-composeで立ち上げる"
tags: ["zabbix", "nanopi"]
---

## dockerをインストール
適宜

## イメージをダウンロード
[zabbix/zabbix-docker: Official Zabbix Dockerfiles](https://github.com/zabbix/zabbix-docker)
https://github.com/zabbix/zabbix-docker/blob/6.4/docker-compose_v3_alpine_mysql_latest.yaml を選択。

## Secretの設定
```
$ printf "zabbix-user" | docker secret create MYSQL_USER -
Error response from daemon: This node is not a swarm manager. Use "docker swarm init" or "docker swarm join" to connect this node to swarm and try again.
```

言われるがままにswarmを起動する。理解、
```
$ docker swarm init
Swarm initialized: current node (1dvllxxxx) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-xxxx 192.168.2.10:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

再度実行する
```
$ printf "zabbix-user" | docker secret create MYSQL_USER -
3756wzulnq99baec031al6uqj
```

TODO