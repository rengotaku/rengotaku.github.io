---
title: "[Ruby]rbenvのinstall listにRubyバージョンが存在しない"
tags: ["ruby", "rbenv"]
---

# バージョン等
**Middleware**

```
$ echo "$(rbenv -v)\n$(ruby-build --version)"
rbenv 1.2.0
ruby-build 20240221
```

**Machine**

```
echo "$(sw_vers)\n$(sysctl -n machdep.cpu.brand_string)"
ProductName:            macOS
ProductVersion:         13.2.1
BuildVersion:           22D68
Apple M2
```

# 問題
`3.0.6`のバージョンがリストに存在しない

```
$ rbenv install --list-all | grep ^3
3.0.0-dev
3.0.0-preview1
3.0.0-preview2
3.0.0-rc1
3.0.0
3.0.1
3.0.2
3.0.3
3.0.4
3.0.5
3.1.0-dev
3.1.0-preview1
3.1.0
3.1.1
3.1.2
```

# 対応
`git -C /Users/hoge/.rbenv/plugins/ruby-build pull`を実行する。

※`brew upgrade ruby-build` のみだとファイルの更新がしない？ため解決しない。
