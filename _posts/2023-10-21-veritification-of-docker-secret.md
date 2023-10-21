---
title: "Docker secreteの検証"
tags: ["docker"]
---

[The Complete Guide to Docker Secrets - Earthly Blog](https://earthly.dev/blog/docker-secrets/)

# 検証
## Dockerの状態

OSはMacOS

```
$ docker version | grep -5 Client
Client:
 Cloud integration: v1.0.35-desktop+001
 Version:           24.0.5
 API version:       1.43
 Go version:        go1.20.6
 Git commit:        ced0996
```

Swarmの状態

```
$ docker info | grep Swarm
 Swarm: inactive
```

## Swarmの起動

```
$ docker swarm init
Swarm initialized: current node (8rp9qhtxxxx) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-227rgzhbbhxxxx 192.168.65.4:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

$ docker info | grep Swarm
 Swarm: active
```
`To add a manager to this swarm...`をすることにより何が行われるか不明。

## Secretを作成

```
$ echo 'This is secret one!' > secure_one.txt
```

## Docker composeを起動

`docker-compose.yml`を作成
```
version: '3'

services:
  server:
    image: alpine:3.11.6
    command: /bin/sh -c 'cat /run/secrets/secure_one'
    secrets:
        - secure_one

secrets:
  secure_one:
    file: secure_one.txt
```

起動すると期待する値が表示される
```
$ docker-compose up
[+] Running 1/0
 ✔ Container test-server-1  Created 0.0s 
Attaching to test-server-1
test-server-1  | This is secret one!
test-server-1 exited with code 0
```

できた。

## Tips
### unsupported external secret secure_one
`$ echo 'This is secret one!' | docker secret create secure_one -`にて値を設定する。
`docker-compose.yml`に下記を宣言すると`unsupported external`が表示される。
```
secrets:
  secure_one:
    external: true
```

secretの設定状況は下記の通り可能。
```
$ docker secret ls                                              
ID                          NAME         DRIVER    CREATED          UPDATED
wxwt8voxxxxxxxxxxxxxxxxxx   secure_one             21 minutes ago   21 minutes ago
```

[Secrets top-level element | Docker Docs](https://docs.docker.com/compose/compose-file/09-secrets/)をみると、`external: true`は利用できる風に記載されている。
[How to use secrets in Docker Compose | Docker Docs](https://docs.docker.com/compose/use-secrets/)には記載ない。前者はdocker-composeのことかと思ったが違う？？？

**対応方法**
[Docker – how do you manage secret values with docker-compose v3.1 – iTecNote](https://itecnote.com/tecnote/r-how-do-you-manage-secret-values-with-docker-compose-v3-1/)をみると、docker-composeの記述をdockerコマンドで読み込んで利用している。（未検証です）どういう場合に利用するか不明。stdin方式はdocker-composeを利用している間は無視して良さそう。

# 考察
Secret機能は、[The Complete Guide to Ruby on Rails Encrypted Credentials | Web-Crunch](https://web-crunch.com/posts/the-complete-guide-to-ruby-on-rails-encrypted-credentials)のようなものだと思い込みがあり理解が難航した。値を暗号化して誤ってコミットした時も安全である類のものと。
だがやっていることは、秘匿の値をファイルをボリュームにアタッチしている感じ。利用したい場合はそのファイルを読み込む。暗号化とかしているわけではない。

[The Complete Guide to Docker Secrets - Earthly Blog](https://earthly.dev/blog/docker-secrets/)を読むと一般的に利用される環境変数への秘匿情報の埋め込みがいけない理由が記載されている
**分かる**
> Secrets stored in an environment variable are more vulnerable to accidental exposure.
> These variables are available to all processes, and it can be difficult to track access.
> Secrets can be shared with subprocesses with little oversight.

**なるほど。。。**
> Applications might accidentally print the entire collection of .env variables during debugging.

個人的には`.env`を細かく分割するなどして運用して回避もできそうとは思った。