---
title: "Zabbix serverをdocker-composeで立ち上げる"
tags: ["zabbix", "nanopi", "openwrt"]
---

## dockerをインストール
適宜

## イメージをダウンロード
[zabbix/zabbix-docker: Official Zabbix Dockerfiles](https://github.com/zabbix/zabbix-docker)
https://github.com/zabbix/zabbix-docker/blob/6.4/docker-compose_v3_alpine_mysql_latest.yaml を選択。

### Tips
※ secretsを利用しているようだが設定が正しくされないのでenv_filesを利用した。

## 設定の書き換え

[Zabbix Docker Installation | Mike Polinowski](https://mpolinowski.github.io/docs/DevOps/Zabbix/2020-07-15--zabbix-docker-installation/2020-07-15/)
を参考に、agentのIPアドレスを確認して管理画面よりIPアドレスを書き換える。

### Tips
**サービスの指定**
下記のようにサービスを選択しないと、zabbix-agent、zabbix-snmptrapsが自動起動しなかった。
```
$ docker-compose up -d zabbix-server zabbix-web-nginx-mysql zabbix-agent mysql-server db_data_mysql
```

**Linkが自動作成されない**
```
observer-zabbix-agent-1            |  18820:20231119:050956.125 Unable to connect to [zabbix-server]:10051 [cannot connect to [[zabbix-server]:10051]: [111] Connection refused]
```
IPアドレスを書き換えてもActiveにならない。下記で明示的にエイリアスを指定する必要がある
```
  zabbix-agent:
    ...
    links:
      - zabbix-server:zabbix-server
```

## 作成したdocker-composeファイル

```
version: "3.5"
services:
  zabbix-server:
    image: zabbix/zabbix-server-mysql:alpine-6.4-latest
    ports:
      - "10051:10051"
    volumes:
      - /tmp/localtime:/etc/localtime:ro # mountエラーになるため変更
      - /etc/timezone:/etc/timezone:ro
      - ./zbx_env/usr/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts:ro
      - ./zbx_env/usr/lib/zabbix/externalscripts:/usr/lib/zabbix/externalscripts:ro
      - ./zbx_env/var/lib/zabbix/dbscripts:/var/lib/zabbix/dbscripts:ro
      - ./zbx_env/var/lib/zabbix/export:/var/lib/zabbix/export:rw
      - ./zbx_env/var/lib/zabbix/modules:/var/lib/zabbix/modules:ro
      - ./zbx_env/var/lib/zabbix/enc:/var/lib/zabbix/enc:ro
      - ./zbx_env/var/lib/zabbix/ssh_keys:/var/lib/zabbix/ssh_keys:ro
      - ./zbx_env/var/lib/zabbix/mibs:/var/lib/zabbix/mibs:ro
      - snmptraps:/var/lib/zabbix/snmptraps:rw
    links:
      - mysql-server:mysql-server
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
    deploy:
      resources:
        limits:
          cpus: "0.70"
          memory: 1G
        reservations:
          cpus: "0.5"
          memory: 512M
    env_file:
      - ./env_vars/.env_db_mysql
    depends_on:
      - mysql-server
    networks:
      zbx_net_backend:
        aliases:
          - zabbix-server
          - zabbix-server-mysql
          - zabbix-server-alpine-mysql
          - zabbix-server-mysql-alpine
      zbx_net_frontend:
    stop_grace_period: 30s
    sysctls:
      - net.ipv4.ip_local_port_range=1024 64999
      - net.ipv4.conf.all.accept_redirects=0
      - net.ipv4.conf.all.secure_redirects=0
      - net.ipv4.conf.all.send_redirects=0
    labels:
      com.zabbix.description: "Zabbix server with MySQL database support"
      com.zabbix.company: "Zabbix LLC"
      com.zabbix.component: "zabbix-server"
      com.zabbix.dbtype: "mysql"
      com.zabbix.os: "alpine"

  zabbix-web-nginx-mysql:
    image: zabbix/zabbix-web-nginx-mysql:alpine-6.4-latest
    ports:
      - "8080:8080"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - ./zbx_env/etc/ssl/nginx:/etc/ssl/nginx:ro
      - ./zbx_env/usr/share/zabbix/modules/:/usr/share/zabbix/modules/:ro
    links:
      - mysql-server:mysql-server
      - zabbix-server:zabbix-server
    deploy:
      resources:
        limits:
          cpus: "0.70"
          memory: 512M
        reservations:
          cpus: "0.5"
          memory: 256M
    env_file:
      - ./env_vars/.env_db_mysql
      - ./env_vars/.env_zabbix
    depends_on:
      - mysql-server
      - zabbix-server
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/ping"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 30s
    networks:
      zbx_net_backend:
        aliases:
          - zabbix-web-nginx-mysql
          - zabbix-web-nginx-alpine-mysql
          - zabbix-web-nginx-mysql-alpine
      zbx_net_frontend:
    stop_grace_period: 10s
    sysctls:
      - net.core.somaxconn=65535
    labels:
      com.zabbix.description: "Zabbix frontend on Nginx web-server with MySQL database support"
      com.zabbix.company: "Zabbix LLC"
      com.zabbix.component: "zabbix-frontend"
      com.zabbix.webserver: "nginx"
      com.zabbix.dbtype: "mysql"
      com.zabbix.os: "alpine"

  zabbix-agent:
    image: zabbix/zabbix-agent:alpine-6.4-latest
    profiles:
      - full
      - all
    ports:
      - "10050:10050"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - ./zbx_env/etc/zabbix/zabbix_agentd.d:/etc/zabbix/zabbix_agentd.d:ro
      - ./zbx_env/var/lib/zabbix/modules:/var/lib/zabbix/modules:ro
      - ./zbx_env/var/lib/zabbix/enc:/var/lib/zabbix/enc:ro
      - ./zbx_env/var/lib/zabbix/ssh_keys:/var/lib/zabbix/ssh_keys:ro
    links:
      - zabbix-server:zabbix-server
    deploy:
      resources:
        limits:
          cpus: "0.2"
          memory: 128M
        reservations:
          cpus: "0.1"
          memory: 64M
      mode: global
    privileged: true
    pid: "host"
    networks:
      zbx_net_backend:
        aliases:
          - zabbix-agent
          - zabbix-agent-passive
          - zabbix-agent-alpine
    stop_grace_period: 5s
    labels:
      com.zabbix.description: "Zabbix agent"
      com.zabbix.company: "Zabbix LLC"
      com.zabbix.component: "zabbix-agentd"
      com.zabbix.os: "alpine"

  mysql-server:
    image: mysql:8.0-oracle
    command:
      - mysqld
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_bin
    volumes:
      - ./zbx_env/var/zabbixdb:/var/lib/mysql:rw
    env_file:
      - ./env_vars/.env_db_mysql
    stop_grace_period: 1m
    networks:
      zbx_net_backend:
        aliases:
          - mysql-server
          - zabbix-database
          - mysql-database

  db_data_mysql:
    image: busybox
    volumes:
      - ./zbx_env/var/zabbixdb:/var/lib/mysql:rw

networks:
  zbx_net_frontend:
    driver: bridge
    driver_opts:
      com.docker.network.enable_ipv6: "false"
    ipam:
      driver: default
      config:
        - subnet: 172.16.238.0/24
  zbx_net_backend:
    driver: bridge
    driver_opts:
      com.docker.network.enable_ipv6: "false"
    internal: true
    ipam:
      driver: default
      config:
        - subnet: 172.16.239.0/24

volumes:
  snmptraps:
```

./env_vars/.env_db_mysql に下記を記載してください
```
MYSQL_USER=xxx
MYSQL_PASSWORD=xxx
MYSQL_ROOT_PASSWORD=xxx
```

./env_vars/.env_zabbix に下記を記載してください
```
ZBX_SERVER_HOST=zabbix-server
ZBX_SERVER_PORT=10051
```

## 別端末をzabbix agentで監視する
### 参考
* [辺境SEの雑多な備忘録: OpenWrtにZabbix Agentを入れてZabbix Serverから監視する](https://blog.silver-cat.info/2021/10/openwrtzabbix-agentzabbix-server.html)
* [Installing/Configuring Zabbix – Iron Comet Customer Portal](https://ironcometportal.com/docs/deploying-openwrt-to-archer-a7-routers/installing-configuring-zabbix/)

### Tips
**agentのログを見たい**
```
logread | tail -10
...
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15700]: Press Ctrl+C to exit.
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15700]: IPv6 support:          YES
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15700]:
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15700]: TLS support:            NO
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15700]: **************************
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15700]: using configuration file: /etc/zabbix_agentd.conf
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15700]: agent #0 started [main process]
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15702]: agent #1 started [collector]
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15704]: agent #3 started [active checks #1]
Sun Nov 19 21:02:19 2023 daemon.info zabbix_agentd[15703]: agent #2 started [listener #1]
```

**portが開いているか確認**
telnetを利用する（インストールする必要がある）
```
# telnet 192.168.2.10 10051
Trying 192.168.2.10...
Connected to 192.168.2.10.
Escape character is '^]'.
Connection closed by foreign host.
```

開いていない場合は下記のエラーが発生する
```
# telnet 192.168.2.10 1234
Trying 192.168.2.10...
telnet: connect to address 192.168.2.10: Connection refused
```

https://blog.silver-cat.info/2021/10/openwrtzabbix-agentzabbix-server.html

`# iptables -A INPUT -p tcp --dport 10050 -j ACCEPT -s <Zabbix ServerのIP>`

**Frontendの表示が遅い**

https://www.initmax.cz/wp-content/uploads/2022/06/zabbix_performance_tuning_6.0.pdf