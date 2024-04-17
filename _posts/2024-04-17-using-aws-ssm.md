---
title: "[AWS]AWS Systems Managerを利用する"
tags: ["aws", "ssm"]
---

# 実行

```
$ aws ssm start-session --target i-instanceid --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"portNumber":["443"],"localPortNumber":["1443"]}' --profile xxxx
```
※ i-instanceid は適宜変更。

```
# コマンド実行時
Starting session with SessionId: hoge-xxxxxxx
Port 1443 opened for sessionId hoge-xxxxxxx.
Waiting for connections...

# 接続すると
Connection accepted for session [hoge-xxxxxxx]
Exiting session with sessionId: hoge-xxxxxxx.
```

## Tips
### SessionManagerPlugin をインストールする。
`aws ssm`を実行すると、`SessionManagerPlugin is not found. Please refer to SessionManager Documentation here: http://docs.aws.amazon.com/console/systems-manager/session-manager-plugin-not-found` が表示される。

下記に従ってダウンロードする。（Macの場合）
https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/install-plugin-macos-overview.html

```
$ curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
$ unzip sessionmanager-bundle.zip
Archive:  sessionmanager-bundle.zip
   creating: sessionmanager-bundle/
  inflating: sessionmanager-bundle/NOTICE
  inflating: sessionmanager-bundle/install
   creating: sessionmanager-bundle/bin/
  inflating: sessionmanager-bundle/bin/session-manager-plugin
  inflating: sessionmanager-bundle/README.md
  inflating: sessionmanager-bundle/THIRD-PARTY
 extracting: sessionmanager-bundle/VERSION
  inflating: sessionmanager-bundle/LICENSE
  inflating: sessionmanager-bundle/seelog.xml.template
  inflating: sessionmanager-bundle/RELEASENOTES.md
$ sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
Creating install directories: /usr/local/sessionmanagerplugin/bin
Creating Symlink from /usr/local/sessionmanagerplugin/bin/session-manager-plugin to /usr/local/bin/session-manager-plugin
Installation successful!
```

### 接続先でエージェントの動作確認

https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/ami-preinstalled-agent.html

```
$ sudo systemctl status amazon-ssm-agent || sudo status amazon-ssm-agent
sudo: systemctl: command not found
amazon-ssm-agent start/running, process 1701
```
