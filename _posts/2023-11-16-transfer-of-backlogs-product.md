---
title: "Backlogのプロジェクト間の移行"
tags: ["saas", "java", "docker"]
---

# 概要
Backlogを移行する必要が出てきた。
Issueの概要、コメント、添付ファイルも移行したい。
Issueの数は100と多くない。

**参考**
https://support-ja.backlog.com/hc/ja/articles/360035644914-%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%81%AE%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E5%88%A5%E3%81%AE%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B9%E3%81%AB%E7%A7%BB%E8%A1%8C%E3%81%A7%E3%81%8D%E3%81%BE%E3%81%99%E3%81%8B-

※Spreadシートなどで移行できる方法もあったがコメントなどの制限があり、添付ファイルの移行も行えず、改行のフォーマットなども面倒で断念した

## 作業
```
$ docker pull adoptopenjdk/openjdk8
$ docker run -ti -v ./backlog-migration-1.6.0.jar:/tmp/backlog-migration-1.6.0.jar adoptopenjdk/openjdk8
```

### コンテナ内作業
```
apt-get update
apt-get install vim
```

#### User一覧を作成
mapping/users.csvの最終カラムを埋めていく（変更がない場合は先頭のカラムをコピペして埋めれば良い）
```
java -jar /tmp/backlog-migration-1.6.0.jar \
init \
--src.key xxxx \
--src.url https://xxxx.backlog.com \
--dst.key xxxx \
--dst.url https://xxxx.backlog.com \
--projectKey OLD_PROJECT:NEW_PROJECT
```

#### Issueなどを移行する

```
java -jar /tmp/backlog-migration-1.6.0.jar \
execute \
--src.key xxxx \
--src.url https://xxxx.backlog.com \
--dst.key xxxx \
--dst.url https://xxxx.backlog.com \
--projectKey OLD_PROJECT:NEW_PROJECT
```

**結果**
```
Backlog Migration 1.6.0 (c) nulab.inc
--------------------------------------------------
--------------------------------------------------
Source URL[https://xxx.backlog.com]
Source access key[xxxx]
Source project key[xxx]
Destination URL[https://xxxx.backlog.com]
Destination access key[xxxx]
Destination project key[xxxx]
Filter[]
Only Import[false]
Fit Issue Key[false]
Maximum number of retries[3]
https.proxyHost[]
https.proxyPort[]
https.proxyUser[]
https.proxyPassword[]
--------------------------------------------------

Checking whether the source is accessible ...
Checking whether the destination is accessible ...
Getting the source project ...
Getting the destination project ...
Checking for the presence of admin role ...
Checking for the presence of project admin role ...
Project [XXXX] already exists. Do you want to import issues and wikis to project [XXXX]? (Check the manual file for details.)  (y/n [n]):y
The mapping users is as follows.
--------------------------------------------------
- はるみ => *xxxxxx
...
--------------------------------------------------

Start migration? (y/n [n]):y

Start export.
--------------------------------------------------
     (2/2) [##########] 100.0% Exported wikis.
     (1/1) [##########] 100.0% Collected issues information.
 (116/116) [##########] 100.0% Exported issues.
project users Exported.
 custom field Exported.
 version Exported.
 issue type Exported.
 category Exported.
 statuses Exported.
--------------------------------------------------
Export completed.

Start convert.
--------------------------------------------------
 project users Converted.
 (869/869) [##########] 100.0% Converted issues.
     (2/2) [##########] 100.0% Converted wikis.
 project key Converted.
--------------------------------------------------
Convert completed.

Start import.
--------------------------------------------------
   (29/29) [##########] 100.0% Imported project users.
     (3/3) [##########] 100.0% Imported category.
     (2/2) [##########] 100.0% Imported issue type.
     (2/2) [##########] 100.0% Imported custom field.
     (2/2) [##########] 100.0% Imported wikis.
    (4/4) [##########] 100.0% [SUCCESSFUL] Imported issues about 2023/03/08.
...
           Could not register comment on issue [XXX-10]. : backlog api request failed.status code - 400message - No comment content.code - 7
  (26/26) [##########] 100.0% [FAILED:1] Imported issues about 2023/03/15.
...
  (10/10) [##########] 100.0% [SUCCESSFUL] Imported issues about 2023/08/14.
           Could not register comment on issue [XXX-3]. : backlog api request failed.status code - 400message - No comment content.code - 7
...
    (4/4) [##########] 100.0% [SUCCESSFUL] Imported issues about 2023/08/23.
           Could not register comment on issue [XXX-68]. : backlog api request failed.status code - 400message - No comment content.code - 7
    (8/8) [##########] 100.0% [FAILED:1] Imported issues about 2023/08/24.
...
  (11/11) [##########] 100.0% [SUCCESSFUL] Imported issues about 2023/10/26.
           Could not register comment on issue [XXX-112]. : backlog api request failed.status code - 400message - No comment content.code - 7
  (25/25) [##########] 100.0% [FAILED:1] Imported issues about 2023/10/27.
...
    (3/3) [##########] 100.0% [SUCCESSFUL] Imported issues about 2023/11/15.
--------------------------------------------------
Import completed.
```
いくつかエラーが発生した。(確認したが問題なさそう)