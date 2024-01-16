---
title: "Gemのバージョンアップ手順書"
tags: ["gem", "ruby"]
---

**前提**
本手順では、`major`バージョンは考慮してません。
影響が低いと思われる、`patch、minor`の一括更新をスコープとしてます。

## 最新のバージョンを確認する(strictあり)
`--strict`はGemfileでの要件を考慮してアップデート計画を表示してくれる。
表示されたgemは全てアップデートすることを目標にする。
```
$ bundle outdated --strict
Fetching gem metadata from https://rubygems.org/.......
Resolving dependencies...

Gem                          Current       Latest        Requested          Groups
actioncable                  6.1.6         6.1.7.6
active_decorator             1.4.0         1.4.1         >= 0               default
active_model_serializers     0.10.13       0.10.14       >= 0               default
capistrano                   3.17.1        3.18.0        >= 0               development, staging, mufg_staging
```

### patch versionのupdate
`outdated —strict`で出力されたpatch version upのgemを指定してversion up
```
$ bundle update gem名 ... --patch
```
outdatedの出力例だと`actioncable`などが対象。

ローカルでテスト(rspecなど)を実行しパスすることを確認する。

`update --patch`で残りのgemのpatch versionをversion up
```
$ bundle update --patch
```

ローカルでテストがパスすることを確認する。


`outdated —strict`で出力されたminor version upのgemを指定してversion up
```
$ bundle update gem名 ... --minor
```
outdatedの出力例だと`capistrano`などが対象。

ローカルでテスト(rspecなど)を実行しパスすることを確認する。

`update --minor`で残りのgemのminor versionをversion up
```
$ bundle update --minor
```

ローカルでテストがパスすることを確認する。

## 最新のバージョンを確認する(strictなし)
Gemfileの要件を無視したアップデート計画を確認する。
内容を見て必要そうなものだけをアップデートすることを目標にする。
`$ bundle outdated`

**最新のバージョンを確認する(strictあり)**と更新手順は同じ。