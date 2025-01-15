---
title: "[DOCKER] MySQL8を起動できるテンプレート"
tags: ["docker", "docker compose", "mysql"]
---

# 概要

MySQL8.0をDocker composeで実行したい。

# 設定

my.cnf
```
[mysqld]
open_files_limit = 1024
table_open_cache = 431
init_connect = SET NAMES utf8mb4;
character_set_server = utf8mb4
collation_server = utf8mb4_bin
innodb_file_per_table = 1
explicit_defaults_for_timestamp = true
bind-address = 0.0.0.0
default-authentication-plugin=mysql_native_password
#mysql_native_password=on
#authentication_policy=mysql_native_password
```

docker-compose.yml
```
services:
  mysql-server:
    image: mysql:8.0-oracle
    command:
      - mysqld
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_bin
    environment:
      - MYSQL_ROOT_PASSWORD=hoge
    ports:
      - "3306:3306"
    volumes:
      - ./my.cnf:/etc/mysql/my.cnf
      - db_data:/var/lib/mysql
    stop_grace_period: 1m

volumes:
  db_data:
    driver: local
    driver_opts:
      type: none
      device: /mnt/ssd1/database_data
      o: bind
```

## Tips
### mysql_native_password を設定する
本設定例だと `my.cnf` に記載する。

```
Unable to connect to host localhost, or the request timed out.
Be sure that the address is correct and that you have the necessary privileges, or try increasing the connection timeout (currently 10 seconds).
MySQL said: Authentication plugin 'caching_sha2_password' reported error: Authentication requires secure connection."
```

### RootユーザでユーザにGrantを付与しようとしたらエラーが発生する
```
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'root'@'xxx.xxx.xxx.xxx' WITH GRANT OPTION;
```

`root you are not allowed to create a user with grant`とエラーになる。

https://stackoverflow.com/a/58167855
```
USE mysql;
CREATE USER 'user'@'localhost' IDENTIFIED BY 'xxxxx';
GRANT ALL ON *.* TO 'user'@'localhost';
FLUSH PRIVILEGES;
```


