---
name: blog-search
description: Jekyll blog _posts内のナレッジを検索する
---

# Jekyll Blog 検索

Jekyll blogの `_posts` ディレクトリ内の投稿を検索する。

## 前提条件

`/blog:init` で初期化済みであること

## 実行方法

### 全文検索
```bash
/blog:search <keyword>
```

### タグ検索
```bash
/blog:search --tag <tag-name>
```

### カテゴリ検索
```bash
/blog:search --category <category-name>
```

### 日付範囲検索
```bash
/blog:search --from 2026-03-01 --to 2026-03-31
```

### 複合検索
```bash
/blog:search docker --tag container --from 2026-01-01
```

## 実行例

```
/blog:search python

=== 検索中 ===

[1] 2026-03-13-python-virtual-environment-setup.md
タイトル: Python仮想環境のセットアップ
カテゴリ: [python, development]
タグ: [venv, environment, setup]
パス: /path/to/_posts/2026-03-13-python-virtual-environment-setup.md

[2] 2026-02-10-python-best-practices.md
タイトル: Pythonベストプラクティス
カテゴリ: [python, coding]
タグ: [python, best-practices]
パス: /path/to/_posts/2026-02-10-python-best-practices.md

=== 検索完了 ===
見つかった投稿: 2件
```

## 検索対象

- Front Matter（title, categories, tags）
- 本文（Markdown）

## 注意事項

- 大文字小文字を区別しない
- 検索結果は新しい順に表示
