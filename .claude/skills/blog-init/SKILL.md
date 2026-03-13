---
name: blog-init
description: Jekyll blogリポジトリのパスを設定し、ブログ投稿環境を初期化する
---

# Jekyll Blog 初期化

Jekyll blogリポジトリをナレッジベースとして使用するための初期設定を行う。

## 実行方法

```
/blog:init
```

Claude Codeが対話形式で以下を確認:
- リポジトリパス
- デフォルトカテゴリ
- デフォルトタグ
- 自動コミット/プッシュの設定

設定は `~/.claude/kb-config.json` に保存される。

## 処理フロー

1. リポジトリパスの入力を求める
2. `_posts` ディレクトリの存在を確認（なければ作成提案）
3. デフォルト設定の入力（Enterでデフォルト値）
4. `~/.claude/kb-config.json` を作成

## 設定ファイル形式

```json
{
  "repositoryPath": "/path/to/rengotaku.github.io",
  "postsDirectory": "_posts",
  "defaultCategory": "tech",
  "defaultTags": ["knowledge"],
  "autoCommit": true,
  "autoPush": false
}
```

## 注意事項

- リポジトリは事前にクローンしておくこと
- `_posts` ディレクトリが存在しない場合は自動作成を提案
